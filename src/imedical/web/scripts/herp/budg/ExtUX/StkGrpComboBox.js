// /名称: StkGrpComboBox.js
// /描述: 封装类组下拉框
// /编写者：zhangdongmei
// /编写日期: 2012.04.10

Ext.ux.StkGrpComboBox = Ext.extend(Ext.form.ComboBox, { 
	fieldLabel : '类&nbsp;&nbsp;&nbsp;&nbsp;组',  // 标题名称 
	StkType:null,						//新加属性，标识类组类型
	LocId:null,					//新加属性，科室id
	UserId:null,				//新加属性，人员id
	emptyText : '类组...',                            
 	forceSelection : true,  // 值为true时将限定选中的值为列表中的值，值为false则允许用户将任意文本设置到字段（默认为 false）。                            
 	selectOnFocus : true,// 值为 ture                            // 时表示字段获取焦点时自动选择字段既有文本(默认为                            // false)。                            
 	//mode : 'local',                                            
 	editable : true, 
 	allowBlank : true,
 	triggerAction : 'all',                            
 	valueField : 'RowId', 
 	minChars : 1,
	valueNotFoundText : '',
 	displayField : 'Description',
	initComponent : function() {
		var myUrl="";
		if(this.LocId==null ||this.LocId==""){
			myUrl=DictUrl+ 'extux.csp?actiontype=StkCatGroup';
		}
		else{
			myUrl=DictUrl+ 'extux.csp?actiontype=GetLocStkCatGroup';
		}
		this.store=new Ext.data.JsonStore({
			autoDestroy:true,
			url:myUrl,
			storeId:'StkGrpStore',
			idProperty:'RowId',
			root:'rows',
			totalProperty:'results',
			fields:['RowId','Description','Default'],
			baseParams:{
				type :this.StkType,
				locId:this.LocId,
				userId:this.UserId
			}
		});
		
		/*
		StkGrpStore.setBaseParam("type",this.StkType);
		StkGrpStore.setBaseParam("locId",this.LocId);
		StkGrpStore.setBaseParam("userId",this.UserId);
		*/
		var me=this;
		this.store.addListener('load',function(store,records,opt){
			for(var i=0;i<records.length;i++){
				var record=records[i];
				if(record.get("Default")=="Y"){
					me.setValue(record.get("RowId"));
					me.originalValue=me.getValue();
				}
			}
		});
 						 
		Ext.ux.StkGrpComboBox.superclass.initComponent.call(this);
		this.store.load();
	}        
});

// /名称: StkGrpComboBox.js
// /描述: 库存分类封装维护
// /编写者：zhangxiao
// /编写日期: 2013.12.02
Ext.ux.StkCatComboBox = Ext.extend(Ext.form.ComboBox, { 
	fieldLabel : '库存分类',  // 标题名称 
	StkType:null,						//新加属性，标识类组类型
	LocId:null,					//新加属性，科室id
	UserId:null,				//新加属性，人员id
	emptyText : '库存分类...',                            
 	forceSelection : true,  // 值为true时将限定选中的值为列表中的值，值为false则允许用户将任意文本设置到字段（默认为 false）。                            
 	selectOnFocus : true,// 值为 ture                            // 时表示字段获取焦点时自动选择字段既有文本(默认为                            // false)。                            
 	//mode : 'local',                                            
 	editable : true, 
 	allowBlank : true,
 	triggerAction : 'all',                            
 	valueField : 'RowId', 
 	minChars : 1,
	valueNotFoundText : '',
 	displayField : 'Description',
	initComponent : function() {
		var myUrl="";
		if(this.LocId==null ||this.LocId==""){
			myUrl=DictUrl+ 'extux.csp?actiontype=StkCat';
		}
		else{
			myUrl=DictUrl+ 'extux.csp?actiontype=GetLocStkCat';
		}
		this.store=new Ext.data.JsonStore({
			autoDestroy:true,
			url:myUrl,
			storeId:'StkCatStore',
			idProperty:'RowId',
			root:'rows',
			totalProperty:'results',
			fields:['RowId','Description','Default'],
			baseParams:{
				type :this.StkType,
				locId:this.LocId,
				userId:this.UserId
			}
		});
		
		/*
		StkGrpStore.setBaseParam("type",this.StkType);
		StkGrpStore.setBaseParam("locId",this.LocId);
		StkGrpStore.setBaseParam("userId",this.UserId);
		*/
		var me=this;
		this.store.addListener('load',function(store,records,opt){
			for(var i=0;i<records.length;i++){
				var record=records[i];
				if(record.get("Default")=="Y"){
					me.setValue(record.get("RowId"));
					me.originalValue=me.getValue();
				}
			}
		});
 						 
		Ext.ux.StkGrpComboBox.superclass.initComponent.call(this);
		this.store.load();
	}        
});


