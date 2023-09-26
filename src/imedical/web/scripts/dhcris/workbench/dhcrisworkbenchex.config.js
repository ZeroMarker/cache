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
		fieldLabel : '状态',
		mode:'local',
		id : 'RisStatus',
		name : 'RisStatus',
		store : RisStatusStore,
		width : 130,
		triggerAction :"all",
		valueField : 'RowId',
		displayField : 'Description'
	}); 
	
	/// 接收科室
	var RecDepStore = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : "dhcrisworkbenchex.new.config.csp?actiontype=GetRecDep&UserRowID="+UserRowID
		}),
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['Description', 'RowId'])
	});
	
	/// 设默认值为当前登陆科室
	RecDepStore.on("load", function(){
		Ext.getCmp('RecDep').setValue(CTLOCID);
	});
	
	RecDepStore.load();
	var RecDep = new Ext.form.ComboBox({
		fieldLabel : '接收科室',
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
   	 	fieldLabel:'卡号',
   	 	emptyText:'卡号...',
    	selectOnFocus:true
	});
	
	var PatientNo = new Ext.form.TextField({
    	id:'PatientNo',
   	 	fieldLabel:'登记号',
   	 	emptyText:'登记号...',
    	selectOnFocus:true
	});

	var StartDate = new Ext.form.DateField({
		fieldLabel : '开始日期',
		id : 'StartDate',
		name : 'StartDate',
		format : 'd/m/Y'		
		,value : new Date()
	});

	var EndDate = new Ext.form.DateField({
		fieldLabel : '结束日期',
		id : 'EndDate',
		name : 'EndDate',
		format : 'd/m/Y'
		,value : new Date()
	});

	var LockFlag = new Ext.form.Checkbox({
		boxLabel : '锁定',
		id : 'LockFlag',
		name : 'LockFlag',
		checked : false
	});
	
	var ReadCardBtn = new Ext.Button({
	    text:'读卡',
	    tooltip:'读卡',
	    handler:function(){
		    searchData();
	    }
	});
	