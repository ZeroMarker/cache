function InitWinScreen(){
 var obj = new Object();
 
//患者姓名*
	obj.txtPatname = new Ext.form.TextField({
	    id : 'txtPatname'
		,fieldLabel : '患者姓名'
		,anchor :'98%'
	});
	//登记号*
	obj.txtPatRegNo = new Ext.form.TextField({
	    id : 'txtPatRegNo'
		,fieldLabel : '登记号'
		,anchor :'98%'
	});
	//性别*
	obj.txtPatSex = new Ext.form.TextField({
	    id : 'txtPatSex'
		,fieldLabel : '性别'
		,anchor :'90%'
	});
	//年龄*
	obj.txtPatAge = new Ext.form.TextField({
	    id : 'txtPatAge'
		,fieldLabel : '年龄'
		,anchor :'90%'
	});
	// 病人科室*
	obj.txtPatLoc = new Ext.form.TextField({
	    id : 'txtPatLoc'
		,fieldLabel : '病人科室'
		,anchor :'98%'
	});
	//病区*
	obj.txtPatWard = new Ext.form.TextField({
	    id : 'txtPatWard'
		,fieldLabel : '病区'
		,anchor :'98%'
	});
	//床号*
	obj.txtPatBedNo = new Ext.form.TextField({
	    id : 'txtPatBedNo'
		,fieldLabel : '床号'
		,anchor :'90%'
	});
	//费别*
	obj.txtAdmReason = new Ext.form.TextField({
	    id : 'txtAdmReason'
		,fieldLabel : '费别'
		,anchor :'90%'
	});
	//手术间
	obj.comOperRoom = new Ext.form.TextField({
	    id : 'comOperRoom'
		,fieldLabel : '手术间'
		,anchor :'90%'
	});
	obj.comOrdNo = new Ext.form.TextField({
	    id : 'comOrdNo'
		,fieldLabel : '台次'
		,anchor :'90%'
	});
obj.Panel11 = new Ext.Panel({
	    id : 'Panel11'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .15
		,layout : 'form'
		,items : [
		    obj.txtPatname
			,obj.txtPatLoc
		]
	});
obj.Panel12 = new Ext.Panel({
	    id : 'Panel12'
		,buttonAlign : 'center'
		,labelWidth:50
		,columnWidth : .15
		,layout : 'form'
		,items : [
		    obj.txtPatRegNo
			,obj.txtPatWard
		]
	});
	obj.Panel13 = new Ext.Panel({
	    id : 'Panel13'
		,buttonAlign : 'center'
		,labelWidth:40
		,columnWidth : .15
		,layout : 'form'
		,items : [
		    obj.txtPatSex
			,obj.txtPatBedNo
		]
	});
	obj.Panel14 = new Ext.Panel({
	    id : 'Panel14'
		,buttonAlign : 'center'
		,labelWidth:40
		,columnWidth : .15
		,layout : 'form'
		,items : [
		    obj.txtPatAge
			,obj.txtAdmReason
		]
	});
	
	obj.Panel15 = new Ext.Panel({
	    id : 'Panel15'
		,buttonAlign : 'center'
		,labelWidth:50
		,columnWidth : .15
		,layout : 'form'
		,items : [
		    obj.comOperRoom
		    ,obj.comOrdNo
		]
	});
	obj.Panel16 = new Ext.Panel({
	    id : 'Panel16'
		,buttonAlign : 'right'
		,columnWidth : .07
		,layout : 'form'
		,items : [
		    //obj.btnSave
		]
	});
	obj.Panel17 = new Ext.Panel({
	    id : 'Panel17'
		,buttonAlign : 'right'
		,columnWidth : .08
		,layout : 'form'
		,items : [
			//obj.btnClose
		]
	});
obj.admInfPanel = new Ext.form.FormPanel({
	    id : 'admInfPanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,title : '病人信息'
		,labelAlign : 'right'
		,region : 'north'
		,layout : 'column'
		,height : 95
		,frame : true
		,items : [
		     obj.Panel11
			,obj.Panel12
			,obj.Panel13
			,obj.Panel14
			,obj.Panel15
			,obj.Panel16
			,obj.Panel17
		]
	});
	
	

 obj.receiveAppDate = new Ext.form.DateField({
	    id : 'receiveAppDate'
		,value : new Date()
		,format : 'd/n/Y'
		,fieldLabel : '<span style="color:red;">*</span>接病人日期'
		,anchor : '95%'
	});
 obj.receiveAppTime = new Ext.form.TimeField({
	    id : 'receiveAppTime'
		,format : 'H:i'
		,increment : 30
		,fieldLabel : '时间'
		,anchor : '90%'
	});
 obj.Panel011 = new Ext.Panel({
	    id : 'Panel011'
		,buttonAlign : 'center'
		,labelWidth:80
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.receiveAppDate
			//,obj.receiveAppTime
		]
	});
   obj.Panel012 = new Ext.Panel({
	    id : 'Panel012'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.receiveAppTime
		]
	});

	
  obj.sendAppDate = new Ext.form.DateField({
	    id : 'sendAppDate'
		,value : new Date()
		,format : 'd/n/Y'
		,fieldLabel : '<span style="color:red;">*</span>送病人日期'
		,anchor : '95%'
	});
  obj.sendAppTime = new Ext.form.TimeField({
	    id : 'sendAppTime'
		,format : 'H:i'
		,increment : 30
		,fieldLabel : '时间'
		,anchor : '90%'
	});
 obj.sPanel1 = new Ext.Panel({
	    id : 'sPanel1'
		,buttonAlign : 'center'
		,labelWidth:80
		,columnWidth : .27
		,layout : 'form'
		,items : [
			obj.sendAppDate
			//,obj.sendAppTime
		]
	});
   obj.sPanel2 = new Ext.Panel({
	    id : 'sPanel2'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .27
		,layout : 'form'
		,items : [
			obj.sendAppTime
		]
	});
	//alert(1);
    obj.btnOpSave=new Ext.Button({
		id : 'btnOpSave'
		,text : '确认'
		,buttonAlign : 'center'
		,height:32
		,width:80
	});
	obj.btnOpClose=new Ext.Button({
		id : 'btnOpClose'
		,text : '关闭'
		,buttonAlign : 'center'
		,height:32
		,width:80
	});
	obj.OpButton1=new Ext.Panel({
		id : 'pnlOpButton1'
		,buttonAlign : 'center'
		,columnWidth : .6
		,layout : 'form'
		,items : [  	
		]
	});
	obj.OpButton2=new Ext.Panel({
		id : 'OpButton2'
		,buttonAlign : 'center'
		,height:60
		,columnWidth : .2
		,layout : 'form'
		,items : [  
           obj.btnOpSave		
		]
	});
	obj.OpButton3=new Ext.Panel({
		id : 'OpButton3'
		,buttonAlign : 'center'
		,height:60
		,columnWidth : .2
		,layout : 'form'
		,items : [  
           obj.btnOpClose	
		]
	});
obj.opPanel = new Ext.form.FormPanel({
		id : 'opPanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,height : 180
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
	     // obj.pnlOpButton1
		 obj.OpButton2
		 ,obj.OpButton3
		]
	});	
	
obj.btnSave=new Ext.Button({
		id : 'btnSave'
		,text : '确认'
		,buttonAlign : 'center'
		,height:32
		,width:80
	});
	obj.btnClose=new Ext.Button({
		id : 'btnClose'
		,text : '关闭'
		,buttonAlign : 'center'
		,height:32
		,width:80
	});
	obj.pnlOpButton1=new Ext.Panel({
		id : 'pnlOpButton1'
		,buttonAlign : 'center'
		,columnWidth : .6
		,layout : 'form'
		,items : [  	
		]
	});
	obj.pnlOpButton2=new Ext.Panel({
		id : 'pnlOpButton2'
		,buttonAlign : 'center'
		,height:60
		,columnWidth : .2
		,layout : 'form'
		,items : [  
           obj.btnSave		
		]
	});
	obj.pnlOpButton3=new Ext.Panel({
		id : 'pnlOpButton3'
		,buttonAlign : 'center'
		,height:60
		,columnWidth : .2
		,layout : 'form'
		,items : [  
           obj.btnClose	
		]
	});
obj.opOtherPanel = new Ext.form.FormPanel({
		id : 'opOtherPanel'
		,buttonAlign : 'center'
		,region:'south'
		,labelWidth : 80
		,height : 180
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
	     // obj.pnlOpButton1
		 obj.pnlOpButton2
		 ,obj.pnlOpButton3
		]
	});	
obj.Panel01 = new Ext.Panel({
	    id : 'Panel01'
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'column'
		,height : 76
		,frame:true
		,items : [
			 obj.Panel011
			 ,obj.Panel012
		]
		
	});
obj.sPanel01 = new Ext.Panel({
	    id : 'sPanel01'
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'column'
		,height : 76
		,frame:true
		,items : [
			 obj.sPanel1
			 ,obj.sPanel2
		]
		
	});

obj.UnSendPanel = new Ext.Panel({
	    id : 'UnSendPanel'
		,buttonAlign : 'center'
		,title : '接病人填写项目'
		,region : 'north'
		,layout : 'form'
		,height : 176
		,frame:true
		,items : [
			 obj.Panel01
			 //,obj.Panel02
			 ,obj.opPanel
		]
		
	});
obj.SendPanel = new Ext.Panel({
	    id : 'SendPanel'
	    
		,buttonAlign : 'center'
		,title : '送病人填写项目'
		,region : 'north'
		//,layout : 'form'
		,height : 176
		,frame:true
		,items : [
			 obj.sPanel01
			//,obj.sPanel2
			,obj.opOtherPanel
		]
		
	});
	
 obj.contentTab = new Ext.TabPanel({
	    //renderTo: Ext.getBody()
		 header : true
		,autoScroll:true 
		,deferredRender:false
		,anchor : '95%'
		,activeTab: 0
		,items: [
		     obj.UnSendPanel
		    ,obj.SendPanel
		]
	});	
obj.contentPanel = new Ext.Panel({
	    id : 'contentPanel'
		,buttonAlign : 'center'
		,layout:'fit'
		,height : 450
		,region : 'center'
		,items : [
		    obj.contentTab
		         ]
	});
	
obj.hiddenPanel = new Ext.Panel({
	    id : 'hiddenPanel'
	    ,buttonAlign : 'center'
	    ,region : 'south'
	    ,hidden : true
	    ,items:[	
	    ]
    });

obj.winScreen = new Ext.Viewport({
	    id : 'winScreen'
		,layout : 'border'
		,items : [
		    obj.admInfPanel
		    ,obj.contentPanel
			,obj.hiddenPanel
			     ]
	});
	
    InitWinScreenEvent(obj);
	//事件处理
	
	obj.btnSave.on('click',obj.btnSave_click,obj)
	obj.btnClose.on('click',obj.btnClose_click,obj)
	obj.btnOpSave.on('click',obj.btnOpSave_click,obj)
	obj.btnOpClose.on('click',obj.btnOpClose_click,obj)
	obj.LoadEvent(arguments);
	return obj;
	

}