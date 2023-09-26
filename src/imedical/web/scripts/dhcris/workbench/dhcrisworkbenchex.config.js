//dhcrisworkbenchex.config.js
  	var UserRowID=session['LOGON.USERID'];
  	var CTLOCID=session['LOGON.CTLOCID'];
  
	var RisStatusStore = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : "dhcrisworkbenchex.new.config.csp?actiontype=GetRisStatus&UserRowID="+UserRowID
		}),
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['Description', 'RowId'])
		//baseParams:{LocId:'',Desc:''}
	});

	RisStatusStore.load();
	var RisStatus = new Ext.form.ComboBox({
		fieldLabel : '״̬',
		mode:'local',
		id : 'RisStatus',
		name : 'RisStatus',
		store : RisStatusStore,
		width : 130,
		triggerAction :"all",
		valueField : 'RowId',
		displayField : 'Description'
	}); 
	
	/// ���տ���
	var RecDepStore = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : "dhcrisworkbenchex.new.config.csp?actiontype=GetRecDep&UserRowID="+UserRowID
		}),
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['Description', 'RowId'])
	});
	
	/// ��Ĭ��ֵΪ��ǰ��½����
	RecDepStore.on("load", function(){
		Ext.getCmp('RecDep').setValue(CTLOCID);
	});
	
	RecDepStore.load();
	var RecDep = new Ext.form.ComboBox({
		fieldLabel : '���տ���',
		mode:'local',
		id : 'RecDep',
		name : 'RecDep',
		store : RecDepStore,
		width : 130,
		valueField : 'RowId',
		triggerAction :"all",
		displayField : 'Description'
	}); 	
	
	var CardNo = new Ext.form.TextField({
    	id:'CardNo',
   	 	fieldLabel:'����',
   	 	emptyText:'����...',
    	selectOnFocus:true
	});
	
	var PatientNo = new Ext.form.TextField({
    	id:'PatientNo',
   	 	fieldLabel:'�ǼǺ�',
   	 	emptyText:'�ǼǺ�...',
    	selectOnFocus:true
	});

	var StartDate = new Ext.form.DateField({
		fieldLabel : '��ʼ����',
		id : 'StartDate',
		name : 'StartDate',
		format : 'd/m/Y'		
		,value : new Date()
	});

	var EndDate = new Ext.form.DateField({
		fieldLabel : '��������',
		id : 'EndDate',
		name : 'EndDate',
		format : 'd/m/Y'
		,value : new Date()
	});

	var LockFlag = new Ext.form.Checkbox({
		boxLabel : '����',
		id : 'LockFlag',
		name : 'LockFlag',
		checked : false
	});
	
	var ReadCardBtn = new Ext.Button({
	    text:'����',
	    tooltip:'����',
	    handler:function(){
		    searchData();
	    }
	});
	