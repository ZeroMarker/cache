// /����: StkGrpComboBox.js
// /����: ��װ����������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.04.10

Ext.ux.StkGrpComboBox = Ext.extend(Ext.form.ComboBox, { 
	fieldLabel : $g('��&nbsp;&nbsp;&nbsp;&nbsp;��'),  // �������� 
	StkType:null,						//�¼����ԣ���ʶ��������
	LocId:null,					//�¼����ԣ�����id
	UserId:null,				//�¼����ԣ���Աid
	emptyText : $g('����...'),                            
 	forceSelection : true,  // ֵΪtrueʱ���޶�ѡ�е�ֵΪ�б��е�ֵ��ֵΪfalse�������û��������ı����õ��ֶΣ�Ĭ��Ϊ false����                            
 	selectOnFocus : true,// ֵΪ ture                            // ʱ��ʾ�ֶλ�ȡ����ʱ�Զ�ѡ���ֶμ����ı�(Ĭ��Ϊ                            // false)��                            
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

