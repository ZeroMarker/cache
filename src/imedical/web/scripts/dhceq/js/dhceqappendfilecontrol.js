Ext.ns("Ext.dhceq");


//===============================================================================


	
//�ļ�����
Ext.dhceq.AppendFileTypeComboBox=Ext.extend(Ext.form.ComboBox, {
	fieldLabel : '��������',
	anchor : '90%',
	valueField : 'TRowID',
	displayField : 'TDesc',
	emptyText : '��������...',
	selectOnFocus : true,
	typeAhead:false,
	pageSize :20,
	listWidth : 200,
	valueNotFoundText : '',
	forceSelection : true,
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
				ClassName:"web.DHCEQ.Process.DHCEQCAppendFileType",
        		QueryName:"GetAppendFileType",
				ArgCnt:0
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
			//var Desc=this.getRawValue();
			this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
			//this.store.setBaseParam("Arg2",Desc);
			//this.store.load({params:{start:0,limit:this.pageSize}});
			this.store.load()
		});
		Ext.dhceq.AppendFileTypeComboBox.superclass.initComponent.call(this);
	}
});
Ext.reg('AppendFileTypeComboBox', Ext.dhceq.AppendFileTypeComboBox); 
