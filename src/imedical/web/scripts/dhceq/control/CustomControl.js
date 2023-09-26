// /名称: 常用组件的简单封装
// /描述: 常用组件的简单封装
// /编写者：Ganrui
// /编写日期: 2015.04.29

Ext.ns("Ext.dhceq");


//===============================================================================


	
//图片类型
Ext.dhceq.PicTypeComboBox=Ext.extend(Ext.form.ComboBox, {
	//服务端识别数据的id名，$Get(%request.Data("PicTypeComboBox",1))
	fieldLabel : '图片类型',
	anchor : '90%',
	valueField : 'TRowID',
	displayField : 'TDesc',
	emptyText : '图片类型...',
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
			if(undefined!=options)//重载load方法增加page与rows参数
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
			this.store.removeAll();    //load之前remove原记录，否则容易出错
			this.store.setBaseParam("Arg2",Desc);
			this.store.load({params:{start:0,limit:this.pageSize}});
		});
		Ext.dhceq.PicTypeComboBox.superclass.initComponent.call(this);
	}
});
Ext.reg('PicTypeComboBox', Ext.dhceq.PicTypeComboBox); 

//===============================消息管理==================================
Msg = {};
// 显示消息
Msg.show = function(type, msg) {
	var title, icon;
	switch (type) {
		case 'error' :
			title = "错误信息";
			icon = Ext.MessageBox.ERROR;
			break;
		case 'warn' :
			title = "警告信息";
			icon = Ext.MessageBox.WARNING;
			break;
		default :
			title = '提示信息';
			icon = Ext.MessageBox.INFO;
	}
	Ext.Msg.show({
				title : title,
				msg : msg,
				buttons : Ext.Msg.OK,
				icon : icon
			});
};
// 显示消息
Msg.flashshow = function(type,msg) {
	Ext.ux.Msg.flash({
		 msg: msg,
		time: 1,
		type: type
		});
};
// 错误信息显示
Msg.error = function(message) {
	Msg.show('error', message);
};

// 警告信息显示
Msg.warn = function(message) {
	Msg.show('warn', message);
};

// 信息显示
Msg.info = function(type,message) {
	//Msg.show('info', message);
	Msg.flashshow(type,message);
};


Msg.delConfirm = function(msg, fn) {
	/*
	if (Ext.type(msg) == "function") {
		fn = msg, msg = null;
	}
	var message = msg || "删除时不可逆的,您确认要删除吗?";
	Ext.Msg.confirm("确认删除", "您确定删除选中的记录吗？", function(btn, txt) {
				if (btn == "yes") {
					fn.apply(window);
				}
			});
			*/
};
    


