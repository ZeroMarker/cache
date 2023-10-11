// JavaScript Document
var editUrl='herp.srm.horizonprjsetupexe.csp';

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
var prawValue = "";
var urawValue = "";
editFun = function(ParticipantsIDs,RelyUnitsIDs) {
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
		myRowid = rowObj[0].get("rowid"); 
	}
///////////////////类型/////////////////////////////  
var eTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '科研'],['2', '教学']]
	});		
		
var eTypeCombox = new Ext.form.ComboBox({
	                   id : 'eTypeCombox',
		           fieldLabel : '类型',
	                   width : 152,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : eTypeDs,
		           ////anchor : '95%',			
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
//////////////////////年度//////////////////////////////////
var eYearDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


eYearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:editUrl+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('eYearField').getRawValue()),
	method:'POST'});
});

var eYearField = new Ext.form.ComboBox({
	id: 'eYearField',
	fieldLabel: '年度',
	width:152,
	listWidth : 260,
	//allowBlank: false,
	store:eYearDs,
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
///////////////////////项目名称//////////////////////////////
var ProjectsNameFields = new Ext.form.TextArea({
	id:'ProjectsNameFields',
	width:152,
	name:'Name',
	fieldLabel: '项目名称',
	//allowBlank: false,
	//emptyText:'项目名称...'
	////anchor: '95%',
	labelSeparator:''
});
///////////////////////项目年限//////////////////////////////
var PrjLifeFields = new Ext.form.TextField({
	id:'PrjLifeFields',
	width:152,
	fieldLabel: '项目年限',
	//allowBlank: false,
	//emptyText:'...年',
	//anchor: '95%',
	labelSeparator:''
});		

/////////////////科室///////////////////////
var DeptsDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


DeptsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:editUrl+'?action=deptList&str='+encodeURIComponent(Ext.getCmp('DeptFields').getRawValue()),
	method:'POST'});
});

var DeptFields = new Ext.form.ComboBox({
	id: 'DeptFields',
	fieldLabel: '科室',
	width:152,
	listWidth : 260,
	//allowBlank: true,
	store:DeptsDs,
	valueField: 'rowid',
	displayField: 'name',
	name:'Dept',
	triggerAction: 'all',
	//emptyText:'请选择科室...',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});


/////////////////负责人////////////////////////////
var HeadDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

HeadDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : editUrl+'?action=applyerList&str='+encodeURIComponent(Ext.getCmp('HeadCombo').getRawValue()),
						method : 'POST'
					});
		});

var HeadCombo = new Ext.form.ComboBox({
            id: 'HeadCombo',
			fieldLabel: '负责人',
			store : HeadDs,
			displayField : 'name',
			valueField : 'rowid',
			name:'Head',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '请选择负责人...',
			width : 152,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:''
		});





//////////////////////项目来源//////////////////////////////////
var addSubSourceDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});
		
addSubSourceDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url :editUrl+'?action=sourceList&str='+encodeURIComponent(Ext.getCmp('addSubSourceCombo').getRawValue()),
                        method:'POST'
					});
		});

var addSubSourceCombo = new Ext.form.ComboBox({
			id:'addSubSourceCombo',
			fieldLabel : '项目来源',
			store : addSubSourceDs,
			displayField : 'Name',
			valueField : 'rowid',
			name:'PTName',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '',
			width : 152,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:''
		});
		
//////////////////////立项部门//////////////////////////////////
var addDepartmentDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
addDepartmentDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url :editUrl+'?action=GetRelyUnit&str='+encodeURIComponent(Ext.getCmp('addDepartmentCombo').getRawValue()),
                        method:'POST'
					});
		});

var addDepartmentCombo = new Ext.form.ComboBox({
			id:'addDepartmentCombo',
			fieldLabel : '立项部门',
			store : addDepartmentDs,
			displayField : 'name',
			valueField : 'rowid',
			name:'Department',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '',
			width : 152,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:''
		});
		
/////////////////////项目编号//////////////////////////
var ProjectNumField = new Ext.form.TextField({
	id:'ProjectNumField',
    fieldLabel: '项目编号',
	width:152,
	name:'SubNo',
    //allowBlank: false,
    //emptyText:'项目编号...',
    //anchor: '95%',
	labelSeparator:''
	});

///////////////////////申请经费///////////////////////////
var AppFundsField = new Ext.form.TextField({
	id:'AppFundsField',
	fieldLabel: '申请经费(万元)',
	width:152,
	name:'AppFunds',
	//allowBlank: false,
	//emptyText:'申请经费（万元）...',
	//anchor: '95%',
	labelSeparator:''
});

/////////////////项目起始时间///////////////////////
var StartDateFields = new Ext.form.DateField({
			id:'StartDateFields',
			fieldLabel: '项目开始日期',
			width:152,
			name:'StartDate',
			//allowBlank:false,
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



////////////////////////项目截止日期///////////////////////
var EndDateFields = new Ext.form.DateField({
			id:'EndDateFields',
			fieldLabel: '项目截止日期',
			width:152,
			name:'EndDate',
			//allowBlank:false,
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
		
		
/////////////////结题时间///////////////////////
var ConDateFields = new Ext.form.DateField({
			id:'ConDateFields',
			fieldLabel: '结题日期',
			width:152,
			name:'ConDate',
			//allowBlank:false,
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


		
//////////////////////依托单位//////////////////////////////////
var RelyUnitDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
RelyUnitDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : editUrl+'?action=GetRelyUnit&str='+encodeURIComponent(Ext.getCmp('eRelyUnits').getRawValue()),
                        method:'POST'
					});
		});

var RelyUnitCombo = new Ext.form.ComboBox({
			id:'eRelyUnits',
			fieldLabel : '单位',
			store : RelyUnitDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '请选择单位',
			width : 152,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:''
		});
///////////////////单位类型/////////////////////////////  
var aUnitTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '依托单位'],['2', '合作单位']]
	});		
		
var aUnitTypeCombox = new Ext.form.ComboBox({
	                   id : 'aUnitTypeCombox',
					   name : 'aUnitTypeCombox',
		           fieldLabel : '单位类型',
	                   width : 152,
		           selectOnFocus : true,
		           //allowBlank : true,
		           store : aUnitTypeDs,
		           ////anchor : '95%',			
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

var RelyUnitsGrid = new Ext.grid.GridPanel({
		id:'RelyUnitsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:'herp.srm.horizonprjsetupexe.csp?action=listrelyunits&start='+0+'&limit='+25+'&RelyUnitsIDs='+RelyUnitsIDs,
		method:'POST'}),
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['unittypeid','rowid','unittype','name'])
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            /* {id: 'rowid', header: '依托单位ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '依托单位名称', dataIndex: 'name',align:'center',width: 258} */
			{id: 'unittypeid', header: '单位类型Id', width: 129, sortable: true, dataIndex: 'unittypeid',hidden:true},
            {id: 'rowid', header: '单位ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '单位类型', dataIndex: 'unittype',align:'center',width: 125},
			{header: '单位名称', dataIndex: 'name',align:'center',width: 125}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 260,
    height: 100
});
///////////////添加多个依托单位按钮////////////////
var eaddRelyUnits  = new Ext.Button({
		text: '增加',
		iconCls: 'edit_add',
		handler: function(){
			var UnitTypeId;
			var RelyUnitId;
			var id = RelyUnitCombo.getValue();
			var unittypeid = aUnitTypeCombox.getValue();
			var RelyUnitName = RelyUnitCombo.getRawValue();
			var UnitTypeName = aUnitTypeCombox.getRawValue();
			var utotal = RelyUnitsGrid.getStore().getCount();
			
			if(utotal>0){	
				for(var i=0;i<utotal;i++){
					var erow = RelyUnitsGrid.getStore().getAt(i).get('rowid');
					var unittyperow=RelyUnitsGrid.getStore().getAt(i).get('unittypeid');
					if(unittypeid!=""){
						if(id!=""){
							if((id==erow)&&(unittyperow==unittypeid)){
								Ext.Msg.show({title:'错误',msg:'您添加了重复的单位!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								return;
							}else{
								RelyUnitId=id;
								UnitTypeId=unittypeid;
							}
					   }else{
							Ext.Msg.show({title:'提示',msg:'请选择您要添加的单位!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
					   }
					}else{
						Ext.Msg.show({title:'提示',msg:'请选择您要添加的单位类型!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(unittypeid==""){
					Ext.Msg.show({title:'提示',msg:'请选择您要添加的单位类型!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					if(id==""){
						Ext.Msg.show({title:'提示',msg:'请选择您要添加的单位!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}else{
						RelyUnitId=id;
						UnitTypeId=unittypeid;
				}	
				}
			}
			var data = new Ext.data.Record({'unittypeid':UnitTypeId,'rowid':RelyUnitId,'unittype':UnitTypeName,'name':RelyUnitName});
			RelyUnitsGrid.stopEditing(); 
			RelyUnitsGrid.getStore().insert(utotal,data);
			if(utotal>0){
				urawValue = RelyUnitsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<utotal;i++){
				  var urow = RelyUnitsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  urawValue = urawValue+","+urow;
				}
			}
			//alert(rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var edelRelyUnits= new Ext.Button({
		text:'删除',iconCls: 'edit_remove',
		handler: function() {  
			var rows = RelyUnitsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = RelyUnitsGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				RelyUnitsGrid.getStore().removeAt(rRowid);//移除所选中的一行
			}

			var utotal = RelyUnitsGrid.getStore().getCount();
			//alert(total);
			if(utotal>0){
				urawValue = RelyUnitsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<utotal;i++){
				  var urow = RelyUnitsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  urawValue = urawValue+","+urow;
				}
			}
			
		}
	});
	

/////////////////////备注//////////////////////////
var RemarkField = new Ext.form.TextField({
	id:'RemarkField',
    fieldLabel: '备注',
	width:152,
	//height: 200,
	name:'Remark',
    allowBlank: true,
    //emptyText:'备注...',
    //anchor: '95%',
	labelSeparator:''

	});


//////////////////参与人员///////////////////////
var eParticipantssDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


eParticipantssDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmprojectsapplyexe.csp?action=applyerList&str='+encodeURIComponent(Ext.getCmp('eParticipants').getRawValue()),
	method:'POST'});
});

var eParticipantsFields = new Ext.form.ComboBox({
	id: 'eParticipants',
	fieldLabel: '参与人员',
	width:152,
	listWidth : 240,
	//allowBlank: false,
	store:eParticipantssDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请重新选择参与人员...',
	name: 'eParticipants',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''

});
////////////////////项目院外参与人员//////////////////////////
var OutPersonField = new Ext.form.TextField({
	id:'OutPersonField',
    fieldLabel: '项目院外参与人员',
	width:152,
    allowBlank: true,
    //emptyText:'项目院外参与人员...',
    //anchor: '95%',
	labelSeparator:''

	});
///////////////////作者位次/////////////////////////////  
var AuthorRangeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '第一'],['2', '第二'], ['3', '第三'], ['4', '第四'], ['5', '第五'],['6', '第六'],['7', '第七'],['8', '第八']]
	});		
		
var AuthorRangeCombox = new Ext.form.ComboBox({
	                   id : 'AuthorRangeCombox',
		           fieldLabel : '参与人位次',
	               width : 152,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : AuthorRangeDs,
		          // //anchor : '95%',			
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
/* var IsTheHosDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '本院职工'],['0', '外院人员'],['2','博士研究生'],['3','硕士研究生']]
	});		
		
var IsTheHosCombox = new Ext.form.ComboBox({
	                   id : 'IsTheHosCombox',
		           fieldLabel : '参与项目时身份',
	               width : 152,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : IsTheHosDs,
		          // //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : '选择...',
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
});	 */
var IsTheHosDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
IsTheHosDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=GetRelyUnit&str='+encodeURIComponent(Ext.getCmp('IsTheHosCombox').getRawValue()),
                        method:'POST'
					});
		});

var IsTheHosCombox = new Ext.form.ComboBox({
			id : 'IsTheHosCombox',
			name :'IsTheHosCombox',
			fieldLabel : '参与人员单位',
			store : IsTheHosDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '',
			width : 152,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:''

		});		

var ParticipantsGrid = new Ext.grid.GridPanel({
		id:'ParticipantsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:'herp.srm.horizonprjsetupexe.csp'+'?action=listparticipants&start='+0+'&limit='+25+'&ParticipantsIDs='+encodeURIComponent(ParticipantsIDs),
		method:'POST'}),
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},
		['rowid','name','rangerowid','range','isthehosrowid','isthehos'])
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '参与人员ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '参与人员名称', dataIndex: 'name',align:'center',width: 100},
             {id: 'rangerowid', header: '作者排名ID', width: 129, sortable: true, dataIndex: 'rangerowid',hidden:true},
            {header: '人员位次', dataIndex: 'range',align:'center',width: 80},
            {id: 'isthehosrowid', header: '参与项目时身份ID', width: 129, sortable: true, dataIndex: 'isthehosrowid',hidden:true},
            {header: '参与项目时身份', dataIndex: 'isthehos',align:'center',width: 80}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 260,
    height: 100
});
///////////////添加多个参与人员按钮////////////////
var eaddParticipants  = new Ext.Button({
		text: '增加',iconCls: 'edit_add',
		handler: function(){
			var ParticipantsId;
			var RangeId;
			var IsTheHosId;
			var ParticipantsName;
			var id = Ext.getCmp('eParticipants').getValue();
			if (id==""){
				id="";
				participantname = Ext.getCmp('OutPersonField').getRawValue();
			}else
			{
				participantname = Ext.getCmp('eParticipants').getRawValue();
			}
			var rangeid = Ext.getCmp('AuthorRangeCombox').getValue();
			var isthehosid = Ext.getCmp('IsTheHosCombox').getValue();
			var outperson = OutPersonField.getValue();
			//alert(id);
			//var ParticipantsName = Ext.getCmp('eParticipants').getRawValue();
			var AuthorRange = Ext.getCmp('AuthorRangeCombox').getRawValue();
			var IsTheHos = Ext.getCmp('IsTheHosCombox').getRawValue();
			var ptotal = ParticipantsGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = ParticipantsGrid.getStore().getAt(i).get('rowid');
					var tmpname = ParticipantsGrid.getStore().getAt(i).get('name');
					var tmprange = ParticipantsGrid.getStore().getAt(i).get('range');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'错误',msg:'您选择了同一个人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
						   if(isthehosid=="")
						   {
						   Ext.Msg.show({title:'错误',msg:'请选择人员单位!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						   }
						   else{
						       if((tmprange==AuthorRange)&&(tmprange!="")&&(AuthorRange!=""))
							   {
									Ext.Msg.show({title:'错误',msg:'不同的参与人员您选择了相同的位次!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									return;
							   }
							   else 
							   {
									ParticipantsId=id;
									ParticipantsName=participantname;
									RangeId=rangeid;
									IsTheHosId=isthehosid;
									//alert(ParticipantsId);
									eParticipantsFields.setValue('');
									eParticipantsFields.setRawValue('');
								}
						}
					}
					}else{
						if(OutPersonField.getValue()==""){
						Ext.Msg.show({title:'提示',msg:'请填写项目外院添加人员!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;}
						else 
						{
							if(participantname==tmpname){
							Ext.Msg.show({title:'错误',msg:'您选择了同一个人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
						   if(isthehosid=="")
						   {
						   Ext.Msg.show({title:'错误',msg:'请选择人员单位!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				    return;
						   }
						   else{
						   {
						   if((tmprange==AuthorRange)&&(tmprange!="")&&(AuthorRange!=""))
							{
								Ext.Msg.show({title:'错误',msg:'不同的参与人员您选择了相同的位次!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							ParticipantsId=id;
							ParticipantsName=participantname;
							RangeId=rangeid;
						    IsTheHosId=isthehosid;
							eParticipantsFields.setValue('');
							eParticipantsFields.setRawValue('');
						   }
						}
					}
						}
					}	
				}
			}else{
				if((id=="")&&(outperson=="")){
					Ext.Msg.show({title:'提示',msg:'请选择院内参与人员或填写院外参与人员!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				if(isthehosid=="")
					{
					Ext.Msg.show({title:'错误',msg:'请选择参与人员单位!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				    return;
					}
				if(rangeid=="")
					{
					Ext.Msg.show({title:'错误',msg:'请选择参与人员位次!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
					}
				else{
					ParticipantsId=id;
					ParticipantsName=participantname;
					RangeId=rangeid;
				    IsTheHosId=isthehosid;	
					eParticipantsFields.setValue('');
					eParticipantsFields.setRawValue('');
				}	
			}
			var data = new Ext.data.Record({'rowid':ParticipantsId,'name':ParticipantsName,'rangerowid':RangeId,'isthehosrowid':IsTheHosId,'range':AuthorRange,'isthehos':IsTheHos});
			ParticipantsGrid.stopEditing(); 
			ParticipantsGrid.getStore().insert(ptotal,data);
			if(ptotal>0){
			   // prawValue=ParticipantsGrid.getStore().getAt(i).get('rowid');
				var authorid = ParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorrangeid = ParticipantsGrid.getStore().getAt(0).get('rangerowid');
				var authoristhehosid = ParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
				prawValue = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				for(var i=1;i<ptotal;i++){
				  //var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  var authorid = ParticipantsGrid.getStore().getAt(i).get('rowid');
				  var authorrangeid = ParticipantsGrid.getStore().getAt(i).get('rangerowid');
				  var authoristhehosid = ParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				  var prow = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				  prawValue = prawValue+","+prow;
				}
			}
		}
	});	

	var edelParticipants = new Ext.Button({
		text:'删除',iconCls: 'edit_remove',
		handler: function() {  
			var rows = ParticipantsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = ParticipantsGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				ParticipantsGrid.getStore().removeAt(rRowid);//移除所选中的一行
			var ptotal = ParticipantsGrid.getStore().getCount();
			if(ptotal>0){
				prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<ptotal;i++){
				  var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  prawValue = prawValue+","+prow;
				}
			}
		}}
	});
	
// ////////////上级拨款////////
var FundGovField = new Ext.form.TextField({
	id:'FundGovField',
    fieldLabel: '上级拨款',
	width:152,
    //allowBlank: false,
    //emptyText:'上级拨款（万元）...',
    //anchor: '95%',
	selectOnFocus : true,
	labelSeparator:''
});
////////////////////医院自筹//////////////////////
var FundOwnField = new Ext.form.TextField({
	id:'FundOwnField',
    fieldLabel: '医院自筹',
	width:152,
    //emptyText:'医院自筹（万元）...',
    //anchor: '95%',
	selectOnFocus : true,
	labelSeparator:''
});
///////////////////已下达//////////////////////
var FundMatchedField = new Ext.form.TextField({
	id:'FundMatchedField',
    fieldLabel: '到位经费（万元）',
	width:152,
    //emptyText:'已匹配（万元）...',
    //anchor: '95%',
	selectOnFocus : true,
	labelSeparator:''
});
//////////////////////是否政府采购/////////////////////
var IsGovBuyStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '否'], ['1', '是']]
		});
var IsGovBuyField = new Ext.form.ComboBox({
			fieldLabel : '是否政府采购',
			width : 152,
			listWidth : 152,
			selectOnFocus : true,
			store : IsGovBuyStore,
			//anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			//emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
			disabled:true,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''
		});
//////////////////////警戒线/////////////////////////
var AlertPercentField = new Ext.form.TextField({
	id:'AlertPercentField',
    fieldLabel: '警戒线',
	width:152,
    //allowBlank: true,
    //emptyText:'90...',
    //anchor: '95%',
	selectOnFocus : true,
	labelSeparator:''
});
//////////////////////出版专著/////////////////////////
var MonographNumField = new Ext.form.TextField({
	id:'MonographNumField',
    fieldLabel: '出版专著',
	width:152,
    allowBlank: true,
    //emptyText:'请填写预计出版专著数...',
    //anchor: '95%',
	selectOnFocus : true,
	labelSeparator:''
});
//////////////////////发表论文/////////////////////////
var PaperNumField = new Ext.form.TextField({
	id:'PaperNumField',
    fieldLabel: '发表论文',
	width:152,
    allowBlank: true,
    //emptyText:'请填写预计发表论文数...',
    //anchor: '95%',
	selectOnFocus : true,
	labelSeparator:''
});//////////////////////专利/////////////////////////
var PatentNumField = new Ext.form.TextField({
	id:'PatentNumField',
    fieldLabel: '专利',
	width:152,
    allowBlank: true,
    //emptyText:'请填写预计专利数...',
    //anchor: '95%',
	selectOnFocus : true,
	labelSeparator:''
});//////////////////////参与制定技术标准/////////////////////////
var InvInCustomStanNumField = new Ext.form.TextField({
	id:'InvInCustomStanNumField',
    fieldLabel: '参与制定技术标准',
	width:152,
    allowBlank: true,
    //emptyText:'请填写预计参与制定技术标准...',
    //anchor: '95%',
	selectOnFocus : true,
	labelSeparator:''
});//////////////////////培养人才/////////////////////////
var TrainNumField = new Ext.form.TextField({
	id:'TrainNumField',
    fieldLabel: '培养人才',
	width:152,
    allowBlank: true,
    //emptyText:'请填写预计培养人才数...',
    //anchor: '95%',
	selectOnFocus : true,
	labelSeparator:''
});//////////////////////举办培训班/////////////////////////
var HoldTrainNumField = new Ext.form.TextField({
	id:'HoldTrainNumField',
    fieldLabel: '举办培训班',
	width:152,
    allowBlank: true,
    //emptyText:'请填写预计举办培训班数...',
    //anchor: '95%',
	selectOnFocus : true,
	labelSeparator:''
});//////////////////////参与培训班/////////////////////////
var InTrainingNumField = new Ext.form.TextField({
	id:'InTrainingNumField',
    fieldLabel: '参与培训班',
	width:152,
    allowBlank: true,
    //emptyText:'请填写预计参与培训班...',
    //anchor: '95%',
	selectOnFocus : true,
	labelSeparator:''
});

///////////////////我院单位位次//////////////////////////////////////////////////////////  
var CompleteUnitDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '第一完成单位'],['2', '第二完成单位'], ['3', '第三完成单位'],
		        ['4', '第四完成单位'],['5', '第五完成单位'],['6', '第六完成单位'],
		        ['7', '第七完成单位'],['8', '第八完成单位']]
	});		
		
var CompleteUnitCombox = new Ext.form.ComboBox({
	               id : 'CompleteUnit',
		           fieldLabel : '我院单位位次',
	               width : 152,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : CompleteUnitDs,
		          // //anchor : '95%',			
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
                   
//////////////////////是否需要伦理审批/////////////////////
var IsEthicalApprovalStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '否'], ['1', '是']]
		});
var IsEthicalApprovalField = new Ext.form.ComboBox({
			fieldLabel : '是否伦理审批',
			width : 152,
			listWidth : 152,
			selectOnFocus : true,
			//allowBlank : false,
			store : IsEthicalApprovalStore,
			////anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			//emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''
		});

var colItems =	[
		{
			layout: 'column',
			border: false,
			defaults: {
				columnWidth: '.5',
				bodyStyle:'padding:0 1px 0',
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
						eTypeCombox,
						eYearField,
					   ProjectsNameFields,                          
					   DeptFields,
					   HeadCombo, 
					   ParticipantsGrid,
					   eParticipantsFields,
					   OutPersonField,
					   IsTheHosCombox,
					   AuthorRangeCombox,
					    {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [{
							xtype : 'displayfield',
							
							columnWidth : .4
							},eaddParticipants,{
							xtype : 'displayfield',
							
							columnWidth : .07
							},edelParticipants]
						},
						addSubSourceCombo
						
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
						
						CompleteUnitCombox,	
						addDepartmentCombo,
						RelyUnitsGrid,
						aUnitTypeCombox,
					    RelyUnitCombo,
					    {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [{
							xtype : 'displayfield',
							columnWidth : .4
							},eaddRelyUnits,{
							xtype : 'displayfield',
							
							columnWidth : .07
							},edelRelyUnits]
						},
//						IsEthicalApprovalField,
						StartDateFields,
						EndDateFields,
						PrjLifeFields,
						AppFundsField,
//						IsGovBuyField,
//						FundOwnField,
//						FundMatchedField,
						AlertPercentField,
//						MonographNumField,
//						PaperNumField,
//						PatentNumField,
//						InvInCustomStanNumField,
//						TrainNumField,
//						HoldTrainNumField,
//						InTrainingNumField,
						RemarkField
						
					]
				 }]
		}
	]		
	// create form panel
  var editFormPanel = new Ext.form.FormPanel({
    labelWidth: 100,
	labelAlign:'right',
	  frame: true,
    items: colItems
	});
	
	editFormPanel.on('afterlayout', function(panel, layout) {
			var rowObj=itemGrid.getSelectionModel().getSelections(); 
			this.getForm().loadRecord(rowObj[0]);
			//FundGovField.setValue(rowObj[0].get("FundGov"));	
			//FundOwnField.setValue(rowObj[0].get("FundOwn"));
			//FundMatchedField.setValue(rowObj[0].get("FundMatched"));			
			//IsGovBuyField.setRawValue(rowObj[0].get("IsGovBuy"));
			EndDateFields.setValue(rowObj[0].get("EndDate"));
			PrjLifeFields.setValue(rowObj[0].get("PrjLife"));
		    StartDateFields.setValue(rowObj[0].get("StartDate"));
			RemarkField.setValue(rowObj[0].get("Remark"));
			AppFundsField.setValue(rowObj[0].get("AppFund"));
			AlertPercentField.setValue(rowObj[0].get("AlertPercent"));
			MonographNumField.setValue(rowObj[0].get("MonographNum"));
			PaperNumField.setValue(rowObj[0].get("PaperNum"));
			PatentNumField.setValue(rowObj[0].get("PatentNum"));
			InvInCustomStanNumField.setValue(rowObj[0].get("InvInCustomStanNum"));
			TrainNumField.setValue(rowObj[0].get("TrainNum"));
			HoldTrainNumField.setValue(rowObj[0].get("HoldTrainNum"));
			InTrainingNumField.setValue(rowObj[0].get("InTrainingNum"));
			//IsEthicalApprovalField.setRawValue(rowObj[0].get("IsEthicalApproval"));
			CompleteUnitCombox.setRawValue(rowObj[0].get("CompleteUnit"));
			eTypeCombox.setRawValue(rowObj[0].get("Type"));
			eYearField.setRawValue(rowObj[0].get("YearCode"));
		});

  // define window and show it in desktop
  var editWindow = new Ext.Window({
  	title: '修改项目立项信息',
	iconCls: 'pencil',
    width: 600,
    height:600,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: editFormPanel,
    buttons: [{
    	text: '保存', iconCls: 'save',
      handler: function() {
      	// check form value
      		var ProjectsName = ProjectsNameFields.getValue();
      		var DeptDr = DeptFields.getValue();
			var HeadDr = HeadCombo.getValue();
			var invent = rowObj[0].get("Participants");
			var ptotal = ParticipantsGrid.getStore().getCount();
			if(ptotal>0){
				//prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorid = ParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorname=""
				if(authorid!==""){
					authorname="";
				}
				else{ authorname = encodeURIComponent(ParticipantsGrid.getStore().getAt(0).get('name'));}
				var authorrangeid = ParticipantsGrid.getStore().getAt(0).get('rangerowid');
				var authoristhehosid = ParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
				prawValue = authorid+"-"+authorname+"-"+authorrangeid+"-"+authoristhehosid;
				for(var i=1;i<ptotal;i++){
				  //var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  var tmpauthorid = ParticipantsGrid.getStore().getAt(i).get('rowid');
				  var tmpauthorname = "";
				  if(tmpauthorid!=""){
					tmpauthorname="";
				  }else{
					tmpauthorname=encodeURIComponent(ParticipantsGrid.getStore().getAt(i).get('name'));}
				  var tmpauthorrangeid = ParticipantsGrid.getStore().getAt(i).get('rangerowid');
				  var tmpauthoristhehosid = ParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				  var tmpprow = tmpauthorid+"-"+tmpauthorname+"-"+tmpauthorrangeid+"-"+tmpauthoristhehosid;
				  prawValue = prawValue+","+tmpprow;
				};
			}
			var Participants = prawValue;
			var SubSource = addSubSourceCombo.getValue();
			//var SubNo = ProjectNumField.getValue();
			var AppFunds = AppFundsField.getValue();
      		var StartDate = StartDateFields.getRawValue();
        	var EndDate = EndDateFields.getRawValue();
			
			var sdate = StartDateFields.getValue();
        	var edate = EndDateFields.getValue();
			
			var PrjLife = PrjLifeFields.getValue();
			var ConDate = ConDateFields.getValue();
			var utotal = RelyUnitsGrid.getStore().getCount();
			if(utotal>0){
				urawValue = RelyUnitsGrid.getStore().getAt(0).get('unittypeid')+"-"+RelyUnitsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<utotal;i++){
				  var unittype=RelyUnitsGrid.getStore().getAt(i).get('unittypeid');
				  var unitrowid = RelyUnitsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  var tmprawvalue=unittype+"-"+unitrowid;
				  urawValue = urawValue+","+tmprawvalue;
				};
			}
			var RelyUnit = urawValue;
			//alert(RelyUnit);
			var SubUser = userdr;
			var Remark = RemarkField.getValue();
      
      //var FundGov = FundGovField.getValue();
			//var FundOwn = FundOwnField.getValue();
			//var FundMatched = FundMatchedField.getValue();
			//var IsGovBuy = IsGovBuyField.getValue();
			var AlertPercent = AlertPercentField.getValue();
			
			 var MonographNum = MonographNumField.getValue();
			 var PaperNum = PaperNumField.getValue();
			 var PatentNum = PatentNumField.getValue();
			 var InvInCustomStanNum = InvInCustomStanNumField.getValue();
			 var TrainNum = TrainNumField.getValue();
			 var HoldTrainNum = HoldTrainNumField.getValue();
			 var InTrainingNum = InTrainingNumField.getValue(); 
		 
		    var CompleteUnit = CompleteUnitCombox.getValue();
			//var IsEthicalApproval = IsEthicalApprovalField.getValue();
			var Type = eTypeCombox.getValue();
			var Year = eYearField.getValue();
			var Department = addDepartmentCombo.getValue();
			
			ProjectsName = ProjectsName.trim();
      		DeptDr = DeptDr.trim();
			HeadDr = HeadDr.trim();
			
			Participants = Participants.trim();
      		SubSource = SubSource.trim();
      		//SubNo = SubNo.trim();
			AppFunds = AppFunds.trim();
			RelyUnit = RelyUnit.trim();
      		Remark = Remark.trim();
      		Department = Department.trim();
      		
      	var projectname=rowObj[0].get("Name");
        var participants=rowObj[0].get("Participants");
        var headdr=rowObj[0].get("Head");
        var startdate=rowObj[0].get("StartDate");
        var enddate=rowObj[0].get("EndDate");
		var prjLife=rowObj[0].get("PrjLife");
        var deptdr=rowObj[0].get("Dept");
        var relyunit=rowObj[0].get("RelyUnit");
        var remark=rowObj[0].get("Remark");
        //var fundown=rowObj[0].get("FundOwn");
        //var fundmatched=rowObj[0].get("FundMatched");
        var appfund=rowObj[0].get("AppFund");
      	//var isgovbuy=rowObj[0].get("IsGovBuy");
      	var alertpercent=rowObj[0].get("AlertPercent");
      	var subsource=rowObj[0].get("PTName");
      	
      	var monographnum=rowObj[0].get("MonographNum");
      	var papernum=rowObj[0].get("PaperNum");
      	var patentnum=rowObj[0].get("PatentNum");
      	var invincustomstannum=rowObj[0].get("InvInCustomStanNum");
      	var trainnum=rowObj[0].get("TrainNum");
      	var holdtrainnum=rowObj[0].get("HoldTrainNum");
      	var intrainingnum=rowObj[0].get("InTrainingNum");
      	//var isethicalapproval=rowObj[0].get("IsEthicalApproval");
      	var completeunit=rowObj[0].get("CompleteUnit");
      	var type=rowObj[0].get("Type");
		var year = rowObj[0].get("YearCode");
		var department=rowObj[0].get("Department");
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
        	if(ProjectsNameFields.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'项目名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(DeptFields.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'科室为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(HeadCombo.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'负责人为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(ParticipantsGrid.getStore().getCount()<1)
			{
      			Ext.Msg.show({title:'错误',msg:'项目参与人员为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(SubSource=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'项目来源为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
            if(CompleteUnitCombox.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'我院单位位次为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		/*
      		if(IsEthicalApprovalField.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'是否伦理审批为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};*/
			if(StartDateFields.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'项目开始时间为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(EndDateFields.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'项目结束时间为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(sdate>edate)
      		{
      			Ext.Msg.show({title:'错误',msg:'项目开始时间不能大于结束时间',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(PrjLifeFields.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'项目年限为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(PrjLifeFields.getRawValue()!=""){
				if (!/[0-9]/.test(PrjLifeFields.getRawValue()))
				{
					Ext.Msg.show({title:'错误',msg:'项目年限只能是数字!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); 
					return ;
				}
			};
      		if(AppFundsField.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'申请经费为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(AppFundsField.getRawValue()!=""){
				if (!/[0-9]/.test(AppFundsField.getRawValue()))
				{
					Ext.Msg.show({title:'错误',msg:'申请经费只能是数字!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); 
					return ;
				}
			};
			if(AlertPercentField.getRawValue()!=""){
				if (!/[0-9]/.test(AlertPercentField.getRawValue()))
				{
					Ext.Msg.show({title:'错误',msg:'警戒线只能是数字!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); 
					return ;
				}
			};
		     if(projectname==ProjectsName){ProjectsName="";}
		     if(participants==Participants){Participants="";}
			 if(headdr==HeadDr){HeadDr="";}
			 if(startdate==StartDate){StartDate="";}
			 if(enddate==EndDate){EndDate="";}
			 if(prjLife==PrjLife){PrjLife="";}
			 if(deptdr==DeptDr){DeptDr="";}
			 if(relyunit==RelyUnit){RelyUnit="";}
			 if(remark==Remark){Remark="";}
			 //if(fundown==FundOwn){FundOwn="";}
			 //if(fundmatched==FundMatched){FundMatched="";}
			 if(appfund==AppFunds){AppFunds="";}
			 //if(isgovbuy==IsGovBuy){IsGovBuy="";}
			 if(alertpercent==AlertPercent){AlertPercent="";}
			 if(subsource==SubSource){SubSource="";}
			 
			 if(monographnum==MonographNum){MonographNum="";}
			 if(papernum==PaperNum){PaperNum="";}
			 if(patentnum==PatentNum){PatentNum="";}
			 if(invincustomstannum==InvInCustomStanNum){InvInCustomStanNum="";}
			 if(trainnum==TrainNum){TrainNum="";}
			 if(holdtrainnum==HoldTrainNum){HoldTrainNum="";}
			 if(intrainingnum==InTrainingNum){InTrainingNum="";}
			 //if(isethicalapproval==IsEthicalApproval){IsEthicalApproval="";}
		     if(completeunit==CompleteUnit){CompleteUnit="";}
			 if(type==Type){Type="";}
			 if(year==Year){Year="";}
			 if(department==Department){Department="";}
		     IsGovBuy="";
			 
        	 if (editFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url:  editUrl+'?action=edit&rowid='+myRowid+'&ProjectsName='+encodeURIComponent(ProjectsName)+'&Participants='+Participants+'&HeadDr='+HeadDr+'&EndDate='+EndDate+'&SubSource='+SubSource+'&AppFunds='+AppFunds+'&StartDate='+StartDate+'&SubUser='+SubUser+'&DeptDr='+DeptDr+'&RelyUnit='+RelyUnit+'&Remark='+encodeURIComponent(Remark)+'&IsGovBuy='+encodeURIComponent(IsGovBuy)+'&AlertPercent='+AlertPercent+'&MonographNum='+''+'&PaperNum='+''+'&PatentNum='+''+'&InvInCustomStanNum='+''+'&TrainNum='+''+'&HoldTrainNum='+''+'&InTrainingNum='+''+'&CompleteUnit='+encodeURIComponent(CompleteUnit)+'&Type='+Type+'&Year='+Year+'&Department='+Department+'&PrjLife='+encodeURIComponent(PrjLife),							
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:25,userdr:userdr}});
									editWindow.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									//if(jsonData.info!=0) message='信息修改有误!';
									if(jsonData.info=='RepProjects') message='输入的项目已经存在!';	
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
        handler: function(){editWindow.close();}
      }]
    });
    editWindow.show();
};
