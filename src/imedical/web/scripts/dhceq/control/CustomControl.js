// /����: ��������ļ򵥷�װ
// /����: ��������ļ򵥷�װ
// /��д�ߣ�Ganrui
// /��д����: 2015.04.29

Ext.ns("Ext.dhceq");


//===============================================================================


	
//ͼƬ����
Ext.dhceq.PicTypeComboBox=Ext.extend(Ext.form.ComboBox, {
	//�����ʶ�����ݵ�id����$Get(%request.Data("PicTypeComboBox",1))
	fieldLabel : 'ͼƬ����',
	anchor : '90%',
	valueField : 'TRowID',
	displayField : 'TDesc',
	emptyText : 'ͼƬ����...',
	selectOnFocus : true,
	typeAhead:false,
	pageSize :20,
	listWidth : 200,
	valueNotFoundText : '',
	forceSelection : true,
	SourceType:"",
	//mode: 'local',
	initComponent:function(){
		this.store=new Ext.data.Store({
			//autoLoad:true,
			proxy : new Ext.data.HttpProxy({
				url:'dhceq.jquery.csp'
									}),
			reader : new Ext.data.JsonReader({
				totalProperty : "total",
				root : 'rows',
				idProperty:'TRowID'		
				},
				 ['TDesc', 'TRowID']
			),
			baseParams:{
				ClassName:"web.DHCEQ.query.DHCEQCPicType",
        		QueryName:"GetPicType",
				Arg1:'',
				Arg2:'',
				Arg3:this.SourceType,//SourceType
				ArgCnt:3
			},
			load : function(options) {
			if(undefined!=options)//����load��������page��rows����
			{
				options.params.page=options.params.start/options.params.limit+1
				options.params.rows=options.params.limit
			}
        	options = Ext.apply({}, options);
        	this.storeOptions(options);
        	if(this.sortInfo && this.remoteSort){
            	var pn = this.paramNames;
            	options.params = Ext.apply({}, options.params);
            	options.params[pn.sort] = this.sortInfo.field;
            	options.params[pn.dir] = this.sortInfo.direction;
        }
        try {
            return this.execute('read', null, options); // <-- null represents rs.  No rs for load actions.
        } catch(e) {
            this.handleException(e);
            return false;
        }
    }
		});
		
		this.on('beforequery',function(e){
			var Desc=this.getRawValue();
			this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
			this.store.setBaseParam("Arg2",Desc);
			this.store.load({params:{start:0,limit:this.pageSize}});
		});
		Ext.dhceq.PicTypeComboBox.superclass.initComponent.call(this);
	}
});
Ext.reg('PicTypeComboBox', Ext.dhceq.PicTypeComboBox); 

//===============================��Ϣ����==================================
Msg = {};
// ��ʾ��Ϣ
Msg.show = function(type, msg) {
	var title, icon;
	switch (type) {
		case 'error' :
			title = "������Ϣ";
			icon = Ext.MessageBox.ERROR;
			break;
		case 'warn' :
			title = "������Ϣ";
			icon = Ext.MessageBox.WARNING;
			break;
		default :
			title = '��ʾ��Ϣ';
			icon = Ext.MessageBox.INFO;
	}
	Ext.Msg.show({
				title : title,
				msg : msg,
				buttons : Ext.Msg.OK,
				icon : icon
			});
};
// ��ʾ��Ϣ
Msg.flashshow = function(type,msg) {
	Ext.ux.Msg.flash({
		 msg: msg,
		time: 1,
		type: type
		});
};
// ������Ϣ��ʾ
Msg.error = function(message) {
	Msg.show('error', message);
};

// ������Ϣ��ʾ
Msg.warn = function(message) {
	Msg.show('warn', message);
};

// ��Ϣ��ʾ
Msg.info = function(type,message) {
	//Msg.show('info', message);
	Msg.flashshow(type,message);
};


Msg.delConfirm = function(msg, fn) {
	/*
	if (Ext.type(msg) == "function") {
		fn = msg, msg = null;
	}
	var message = msg || "ɾ��ʱ�������,��ȷ��Ҫɾ����?";
	Ext.Msg.confirm("ȷ��ɾ��", "��ȷ��ɾ��ѡ�еļ�¼��", function(btn, txt) {
				if (btn == "yes") {
					fn.apply(window);
				}
			});
			*/
};
    


