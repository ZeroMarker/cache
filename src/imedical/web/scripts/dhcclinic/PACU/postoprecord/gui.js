function InitViewScreen()
{ 
  var obj=new Object();
  obj.labTitle1=new Ext.form.Label(
	{
		id:'labTitle1'
		,text:'中国医科大学附属第一医院'
		,anchor : '95%'
		,height:20
		,cls:'title1'
	})
  obj.labTitle2=new Ext.form.Label(
   {
         id:'labTitle2'
		,text:'麻醉术后记录'
		,anchor : '95%'
		,cls:'title2'
   })
  obj.txtBedCode = new Ext.form.TextField({
		id : 'txtBedCode'
		,fieldLabel : 'PACU床号'
		,labelAlign :'right' 
		,anchor : '95%'
	});
	obj.txtHosNum = new Ext.form.TextField({
		id : 'txtHosNum'
		,fieldLabel : '住院号'
		,anchor : '95%'
	});
  obj.pnlTitle=new Ext.Panel({
		id : 'pnlTitle'
		,buttonAlign : 'center'
		,columnWidth : .62
		,layout:'form'
		,items:[
		 obj.labTitle1,
		 obj.labTitle2
		]
	});
  obj.pnlRTitle=new Ext.Panel({
		id : 'pnlRTitle'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
		  obj.txtBedCode
		 ,obj.txtHosNum
		]
	});
  obj.pnlBanner=new Ext.form.FormPanel({
		id : 'pnlBanner'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,height : 85
		,title : '麻醉术后记录'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,animate:true
		,items:[
		 obj.pnlTitle,
		 obj.pnlRTitle
		]
	});
	obj.txtName = new Ext.form.TextField({
		id : 'txtName'
		,fieldLabel : '姓名'
		,anchor : '100%'
	});
	obj.pnlPatInfoA1=new Ext.Panel({
		id : 'pnlPatInfoA1'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
		 obj.txtName
		]
	});
   var data=[
   ['1','男'],
   ['2','女']
   ]
    obj.sexStoreProxy=data;
	obj.sexStore = new Ext.data.Store({
	proxy: new Ext.data.MemoryProxy(data),
	reader: new Ext.data.ArrayReader({
		}, 
		[
		  {name: 'code'}
		 ,{name: 'desc'}
		])
	});
	obj.comSex=new Ext.form.ComboBox({
	 id:'comSex'
	 ,store:obj.sexStore
	 ,minChars:1
	 ,value:'' 
	 ,displayField : 'desc'
	 ,fieldLabel : '性别'
	 ,valueField : 'code'
	 ,triggerAction : 'all'
	 ,anchor : '100%'
	})
	obj.pnlPatInfoA2=new Ext.Panel({
		id : 'pnlPatInfoA2'
		,buttonAlign : 'center'
		,columnWidth : .14
		,layout : 'form'
		,items:[
		 obj.comSex
		]
	});
	obj.txtAge = new Ext.form.TextField({
		id : 'txtAge'
		,fieldLabel : '年龄'
		,anchor : '95%'
	});
	obj.pnlPatInfoA3=new Ext.Panel({
		id : 'pnlPatInfoA3'
		,buttonAlign : 'center'
		,columnWidth : .15
		,layout : 'form'
		,items:[
		 obj.txtAge
		]
	});
	obj.txtCtLoc = new Ext.form.TextField({
		id : 'txtCtLoc'
		,fieldLabel : '科室'
		,anchor : '95%'
	});
	obj.pnlPatInfoA4=new Ext.Panel({
		id : 'pnlPatInfoA4'
		,buttonAlign : 'center'
		,columnWidth : .26
		,layout : 'form'
		,items:[
		 obj.txtCtLoc
		]
	});
	obj.pnlPatInfoA= new Ext.Panel({
		id : 'pnlPatInfoA'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
		obj.pnlPatInfoA1,
		obj.pnlPatInfoA2,
		obj.pnlPatInfoA3,
		obj.pnlPatInfoA4
		]
	});
	obj.txtAnMethod= new Ext.form.TextField({
		id : 'pnlAnMethod'
		,fieldLabel : '麻醉方法'
		,anchor : '92%'
	});
	obj.pnlPatInfoB= new Ext.Panel({
		id : 'pnlPatInfoB'
		,buttonAlign : 'center'
		,layout : 'form'
		,items:[
		obj.txtAnMethod
		]
	});
	obj.txtBP = new Ext.form.TextField({
		id : 'txtBP'
		,fieldLabel : '血压'
		,vtype:'BP'
		,anchor : '95%'
	});
	 obj.labBP=new Ext.form.Label(
	{
		id:'labBP'
		,text:'mmHg'
		,anchor : '95%'
		,height:20
	})
	obj.pnlAnRecoveryA1=new Ext.Panel({
		id : 'pnlAnRecoveryA1'
		,buttonAlign : 'center'
		,columnWidth : .18
		,layout : 'form'
		,items:[
		 obj.txtBP
		]
	});
	obj.labAnRecoveryA1=new Ext.Panel({
		id : 'labAnRecoveryA1'
		,buttonAlign : 'center'
		,columnWidth : .07
		,layout : 'form'
		,items:[
		 obj.labBP
		]
	});
	obj.txtHR = new Ext.form.TextField({
		id : 'txtHR'
		,fieldLabel : '心率'
		,anchor : '95%'
	});
	obj.pnlAnRecoveryA2=new Ext.Panel({
		id : 'pnlAnRecoveryA2'
		,buttonAlign : 'center'
		,columnWidth : .18
		,layout : 'form'
		,items:[
		 obj.txtHR
		]
	});
	 obj.labHR=new Ext.form.Label(
	{
		id:'labHR'
		,text:'次/分'
		,anchor : '95%'
		,height:20
	})
	obj.labAnRecoveryA2=new Ext.Panel({
		id : 'labAnRecoveryA2'
		,buttonAlign : 'center'
		,columnWidth : .07
		,layout : 'form'
		,items:[
		 obj.labHR
		]
	});
	obj.txtSPO2= new Ext.form.TextField({
		id : 'txtSPO2'
		,fieldLabel : 'SPO2'
		,anchor : '95%'
	});
	obj.pnlAnRecoveryA3=new Ext.Panel({
		id : 'pnlAnRecoveryA3'
		,buttonAlign : 'center'
		,columnWidth : .18
		,layout : 'form'
		,items:[
		 obj.txtSPO2
		]
	});
	obj.labSPO2=new Ext.form.Label(
	{
		id:'labSPO2'
		,text:'%'
		,anchor : '95%'
		,height:20
	})
	obj.labAnRecoveryA3=new Ext.Panel({
		id : 'labAnRecoveryA3'
		,buttonAlign : 'center'
		,columnWidth : .07
		,layout : 'form'
		,items:[
		 obj.labSPO2
		]
	});
	obj.txtRR= new Ext.form.TextField({
		id : 'txtRR'
		,fieldLabel : '呼吸频率'
		,anchor : '95%'
	});
	
	obj.pnlAnRecoveryA4=new Ext.Panel({
		id : 'pnlAnRecoveryA4'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .18
		,layout : 'form'
		,items:[
		 obj.txtRR
		]
	});
	obj.labRR=new Ext.form.Label(
	{
		id:'labRR'
		,text:'次/分'
		,anchor : '95%'
		,height:20
	})
	obj.labAnRecoveryA4=new Ext.Panel({
		id : 'labAnRecoveryA4'
		,buttonAlign : 'center'
		,columnWidth : .07
		,layout : 'form'
		,items:[
		 obj.labRR
		]
	});
	obj.pnlAnRecoveryA = new Ext.Panel({
		id : 'pnlAnRecoveryA'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
		obj.pnlAnRecoveryA1,
		obj.labAnRecoveryA1,
		obj.pnlAnRecoveryA2,
		obj.labAnRecoveryA2,
		obj.pnlAnRecoveryA3,
		obj.labAnRecoveryA3,
		obj.pnlAnRecoveryA4,
		obj.labAnRecoveryA4
		]
	});
	
	
   var data=[
   ['1','清醒'],
   ['2','不清醒'],
   ['3','躁动']
   ]
    obj.senseStoreProxy=data;
	obj.senseStore = new Ext.data.Store({
	proxy: new Ext.data.MemoryProxy(data),
	reader: new Ext.data.ArrayReader({
		}, 
		[
		  {name: 'code'}
		 ,{name: 'desc'}
		])
	});
	obj.comSense=new Ext.form.ComboBox({
	 id:'comSense'
	 ,store:obj.senseStore
	 ,minChars:1
	 ,value:'' 
	 ,displayField : 'desc'
	 ,fieldLabel : '神志'
	 ,valueField : 'code'
	 ,triggerAction : 'all'
	 ,anchor : '95%'
	})
	obj.pnlAnRecoveryB1=new Ext.Panel({
		id : 'pnlAnRecoveryB1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		 obj.comSense
		]
	});
	
   var data=[
   ['1','是'],
   ['2','否']
   ]
    obj.nauseaStoreProxy=data;
	obj.nauseaStore = new Ext.data.Store({
	proxy: new Ext.data.MemoryProxy(data),
	reader: new Ext.data.ArrayReader({
		}, 
		[
		  {name: 'code'}
		 ,{name: 'desc'}
		])
	});
	obj.comNausea=new Ext.form.ComboBox({
	 id:'comNausea'
	 ,store:obj.nauseaStore
	 ,minChars:1
	 ,value:'' 
	 ,displayField : 'desc'
	 ,fieldLabel : '恶心'
	 ,valueField : 'code'
	 ,triggerAction : 'all'
	 ,anchor : '95%'
	})
	obj.pnlAnRecoveryB2=new Ext.Panel({
		id : 'pnlAnRecoveryB2'
		,buttonAlign : 'center'
		,labelWidth:40
		,columnWidth : .14
		,layout : 'form'
		,items:[
		 obj.comNausea
		]
	});
	
   var data=[
   ['1','是'],
   ['2','否']
   ]
    obj.vomitStoreProxy=data;
	obj.vomitStore = new Ext.data.Store({
	proxy: new Ext.data.MemoryProxy(data),
	reader: new Ext.data.ArrayReader({
		}, 
		[
		  {name: 'code'}
		 ,{name: 'desc'}
		])
	});
	obj.comVomit=new Ext.form.ComboBox({
	 id:'comVomit'
	 ,store:obj.vomitStore
	 ,minChars:1
	 ,value:'' 
	 ,displayField : 'desc'
	 ,fieldLabel : '呕吐'
	 ,valueField : 'code'
	 ,triggerAction : 'all'
	 ,anchor : '100%'
	})
	obj.pnlAnRecoveryB3=new Ext.Panel({
		id : 'pnlAnRecoveryB3'
		,buttonAlign : 'center'
		,labelWidth:40
		,columnWidth : .14
		,layout : 'form'
		,items:[
		 obj.comVomit
		]
	});
   var data=[
   ['1','无'],
   ['2','有']
   ]
    obj.hoarseStoreProxy=data;
	obj.hoarseStore = new Ext.data.Store({
	proxy: new Ext.data.MemoryProxy(data),
	reader: new Ext.data.ArrayReader({
		}, 
		[
		  {name: 'code'}
		 ,{name: 'desc'}
		])
	});
	obj.comHoarse=new Ext.form.ComboBox({
	 id:'comHoarse'
	 ,store:obj.hoarseStore
	 ,minChars:1
	 ,value:'' 
	 ,displayField : 'desc'
	 ,fieldLabel : '声音嘶哑'
	 ,valueField : 'code'
	 ,triggerAction : 'all'
	 ,anchor : '95%'
	})
	obj.pnlAnRecoveryB4=new Ext.Panel({
		id : 'pnlAnRecoveryB4'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .18
		,layout : 'form'
		,items:[
		 obj.comHoarse
		]
	});
   var data=[
   ['1','无'],
   ['2','有']
   ]
    obj.motionHinderStoreProxy=data;
	obj.motionHinderStore = new Ext.data.Store({
	proxy: new Ext.data.MemoryProxy(data),
	reader: new Ext.data.ArrayReader({
		}, 
		[
		  {name: 'code'}
		 ,{name: 'desc'}
		])
	});
	obj.comMotionHinder=new Ext.form.ComboBox({
	 id:'comMotionHinder'
	 ,store:obj.motionHinderStore
	 ,minChars:1
	 ,value:'' 
	 ,displayField : 'desc'
	 ,fieldLabel : '肢体感觉/运动障碍'
	 ,valueField : 'code'
	 ,triggerAction : 'all'
	 ,anchor : '100%'
	})
	obj.pnlAnRecoveryB5=new Ext.Panel({
		id : 'pnlAnRecoveryB5'
		,buttonAlign : 'center'
		,labelWidth:120
		,columnWidth : .26
		,layout : 'form'
		,items:[
		 obj.comMotionHinder
		]
	});
	obj.pnlAnRecoveryB = new Ext.Panel({
		id : 'pnlAnRecoveryB'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
		obj.pnlAnRecoveryB1,
		obj.pnlAnRecoveryB2,
		obj.pnlAnRecoveryB3,
		obj.pnlAnRecoveryB4,
		obj.pnlAnRecoveryB5
		]
	});
	obj.txtSpSituation= new Ext.form.TextField({
		id : 'txtSpSituation'
		,fieldLabel : '特殊情况'
		,anchor : '92%'
	});
	obj.pnlAnRecoveryC = new Ext.Panel({
		id : 'pnlAnRecoveryC'
		,labelWidth:58
		,buttonAlign : 'center'
		,layout : 'form'
		,items:[
		 obj.txtSpSituation
		]
	});
	obj.pnlBaseInfo=new Ext.form.FormPanel({
	    id : 'pnlBaseInfo'
		,buttonAlign : 'center'
		,bodyBorder : 'padding:0 0 0 0'
	    ,labelWidth:58
		,labelAlign : 'right'
		,height : 140
		,title : ''
		,region : 'north'
		,frame : true
		,animate:true
		,items:[
         obj.pnlPatInfoA
		,obj.pnlPatInfoB
		,obj.pnlAnRecoveryA
		,obj.pnlAnRecoveryB
		,obj.pnlAnRecoveryC
		]
	})
   obj.recordListGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.recordListGridPanelStore = new Ext.data.Store({
		proxy: obj.recordListGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'id'
		}, 
		[
			 {name: 'id', mapping: 'id'}
			,{name: 'startTime', mapping: 'startTime'}
			,{name: 'bpAnoNote', mapping: 'bpAnoNote'}
			,{name: 'bpAnoId', mapping: 'bpAnoId'}
			,{name: 'hrAnoQty', mapping: 'hrAnoQty'}
			,{name: 'hrAnoId', mapping: 'hrAnoId'}
			,{name: 'spAnoQty', mapping: 'spAnoQty'}
			,{name: 'spAnoId', mapping: 'spAnoId'}
			,{name: 'dvAnoQty', mapping: 'dvAnoQty'}
			,{name: 'dvAnoId', mapping: 'dvAnoId'}
			,{name: 'scAnoNote', mapping: 'scAnoNote'}
			,{name: 'scAnoId', mapping: 'scAnoId'}
		])
	});
	var textEditor = new Ext.grid.GridEditor(new Ext.form.TextField());
	var timeEditor=new Ext.grid.GridEditor( new Ext.form.TimeField(
     {
	 empty:'请选择时间',  
     minValue:'07:30 AM',  
     maxValue:'23:55 PM',  
     format:'H:i',  
     increment:5,  
     invalidText:'日期格式无效，请选择时间或输入有效格式的时间' } 
	))
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
		     {header: ' ', width: 25, dataIndex: 'id',sortable: true}
			,{header: '时间', width: 70, dataIndex: 'startTime', editor: timeEditor}
			,{header: '血压 mmHg'
			  , width: 75
			  , dataIndex: 'bpAnoNote'
			  , editor:new Ext.form.TextField(
			  {
			    vtype:'BP'
			  }
			  ) 
			  }
			,{header: '心率 次/分', width:70, dataIndex: 'hrAnoQty', editor: textEditor}
			,{header: 'SPO2', width: 70, dataIndex: 'spAnoQty', editor: textEditor}
			,{header: '引流量 ml', width: 70, dataIndex: 'dvAnoQty', editor: textEditor}
			,{header: '处置/特殊情况', width: 336, dataIndex: 'scAnoNote', editor: textEditor}
		]
	})
	Ext.apply(Ext.form.VTypes, {
    BP:function(val,obj)
	{
	  var regStr=/\d+\/\d+/
	  var flag=regStr.test(val)
	  if(flag==false)
	  {
	   obj.vtypeText="输入的格式有误！"
	   return false;
	  }
	  return true
	}
    });
	obj.recordListGridPanel = new Ext.grid.EditorGridPanel({
		id : 'recordListGridPanel'
		,store : obj.recordListGridPanelStore
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,title:'PACU记录单'
		,frame : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm
		,viewConfig:
		{
          //forceFit: true
		}
	});
     obj.txtInScore= new Ext.form.TextField({
		id : 'txtInScore'
		,fieldLabel : '入PACU评分'
		,anchor : '95%'
	});
	obj.pnlInScore=new Ext.Panel({
	     id : 'pnlInScore'
        ,labelWidth:80
		,columnWidth : .3
		,layout:'form'
		,items:[
		obj.txtInScore
		]
	})
	 obj.labInScore=new Ext.form.Label(
	{
		id:'labInScore'
		,text:'分'
		,anchor : '95%'
		,height:20
	})
	obj.labPnlInScore=new Ext.Panel({
		id : 'labPnlInScore'
		,buttonAlign : 'center'
		,columnWidth : .07
		,layout : 'form'
		,items:[
		 obj.labInScore
		]
	});
	 obj.txtOutScore= new Ext.form.TextField({
		id : 'txtOutScore'
		,fieldLabel : '出PACU评分'
		,anchor : '95%'
	});
	obj.pnlOutScore=new Ext.Panel({
	     id : 'pnlOutScore'
        ,labelWidth:80
		,columnWidth : .3
		,layout:'form'
		,items:[
		obj.txtOutScore
		]
	})
	 obj.labOutScore=new Ext.form.Label(
	{
		id:'labOutScore'
		,text:'分'
		,anchor : '95%'
		,height:20
	})
	obj.labPnlOutScore=new Ext.Panel({
		id : 'labPnlOutScore'
		,buttonAlign : 'center'
		,columnWidth : .07
		,labelWidth:50
		,layout : 'form'
		,items:[
		 obj.labOutScore
		]
	});
	obj.pnlScore=new Ext.Panel({
	     id : 'pnlScore'
		,title:'steward评分'
		,frame : true
		,buttonAlign : 'center'
		,layout:'column'
		,animate:true
		,items:[
		obj.pnlInScore,
		obj.labPnlInScore,
		obj.pnlOutScore,
		obj.labPnlOutScore
		]
	})
	obj.txtAppendix=new Ext.form.TextArea({
	 id:'txtAppendix'
	 ,grow:true
	 ,anchor : '100%'
	 ,hideLabel:true 
     })
	obj.pnlAppendix=new Ext.Panel({
	     id : 'pnlAppendix'
		,buttonAlign : 'center'
		,height : 120
		,title:'附录'
		,frame : true
		,animate:true
		,layout:'form'
		,items:[
		obj.txtAppendix
		]
	})
	obj.pnlSouth=new Ext.Panel({
	     id : 'pnlSouth'
		,height : 165
		,title:''
		,region : 'south'
		,layout:'form'
		,frame : true
		,items:[
		obj.pnlScore,
		obj.pnlAppendix
		]
	})
	obj.pnlMainLeft=new Ext.Panel({
	     id : 'pnlMainLeft'
		,buttonAlign : 'center'
		,region : 'west'
		,animate:true
		,items:[
		]
	})
	obj.pnlMainRight=new Ext.Panel({
	     id : 'pnlMainRight'
		,buttonAlign : 'center'
		,region : 'east'
		,animate:true
		,items:[
		]
	})
	obj.pnlMain=new Ext.Panel({
	     id : 'pnlMain'
		,buttonAlign : 'center'
		,height : 500
		,region : 'center'
		,layout : 'border'
		,frame : true
		,animate:true
		,items:[
		 obj.pnlBaseInfo
		,obj.recordListGridPanel
		,obj.pnlSouth
		]
	})
	obj.anDoctorStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url: ExtToolSetting.RunQueryPageURL
		}));
	obj.anDoctorStore = new Ext.data.Store({
		proxy: obj.anDoctorStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctcpId'
		}, 
		[
			 {name: 'checked', mapping : 'checked'}
			,{name: 'ctcpId', mapping: 'ctcpId'}
			,{name: 'ctcpDesc', mapping: 'ctcpDesc'}
			,{name: 'ctcpAlias', mapping: 'ctcpAlias'}
		])
	});
	 obj.comAnDoctor=new Ext.form.ComboBox({
	 id:'comAnDoctor'
	 ,minChars:1
	 ,value:'' 
	 ,store : obj.anDoctorStore
	 ,displayField : 'ctcpDesc'
	 ,fieldLabel : '麻醉医生'
	 ,valueField : 'ctcpId'
	 ,triggerAction : 'all'
	 ,anchor : '85%'
	})
	obj.pnlLast1=new Ext.Panel({
	     id : 'pnlLast1'
		,buttonAlign : 'center'
		,columnWidth:.3
		,labelWidth:60
		,layout : 'form'
		,items:[
        obj.comAnDoctor
		]
	})
	obj.anNurseStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url: ExtToolSetting.RunQueryPageURL
		}));
	obj.anNurseStore = new Ext.data.Store({
		proxy: obj.anNurseStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctcpId'
		}, 
		[
			 {name: 'checked', mapping : 'checked'}
			,{name: 'ctcpId', mapping: 'ctcpId'}
			,{name: 'ctcpDesc', mapping: 'ctcpDesc'}
			,{name: 'ctcpAlias', mapping: 'ctcpAlias'}
		])
	});
	 obj.comAnNurse=new Ext.form.ComboBox({
	 id:'comAnNurse'
	 ,store:obj.anNurseStore
	 ,minChars:1
	 ,value:'' 
	 ,displayField : 'ctcpDesc'
	 ,fieldLabel : '麻醉护士'
	 ,valueField : 'ctcpId'
	 ,triggerAction : 'all'
	 ,anchor : '85%'
	})
	obj.pnlLast2=new Ext.Panel({
	  id : 'pnlLast2'
	 ,buttonAlign : 'center'
	 ,columnWidth:.3
	 ,labelWidth:60
	 ,layout : 'form'
	 ,items:[
        obj.comAnNurse
		]
	})
	obj.frmDate = new Ext.form.DateField({
		id : 'frmDate'
		,value : new Date()
		,format : 'd/m/Y'
		,fieldLabel : '时间'
		,anchor : '95%'
	});
	obj.pnlLast3=new Ext.Panel({
	  id : 'pnlLast3'
	 ,buttonAlign : 'center'
	 ,columnWidth:.25
	 ,layout : 'form'
	 ,items:[
        obj.frmDate
		]
	})
	 obj.txtTime=new Ext.form.TimeField({
	 id:'txtTime'
	 ,hideLabel:true
	 ,anchor : '85%'
	 ,empty:'请选择时间'  
     ,minValue:'07:30 AM' 
     ,maxValue:'23:55 PM'
     ,format:'H:i'  
     ,increment:5
     ,invalidText:'时间格式无效，请选择时间或输入有效格式的时间' 
	 })
	obj.pnlLast4=new Ext.Panel({
	  id : 'pnlLast4'
	 ,buttonAlign : 'center'
	 ,columnWidth:.15
	 ,layout : 'form'
	 ,items:[
        obj.txtTime
		]
	})
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,text : '保存'
	});
	obj.btnPrint = new Ext.Button({
		id : 'btnPrint'
		,text : '打印'
	});
	obj.pnlLast=new Ext.form.FormPanel({
	     id : 'pnlLast'
		,buttonAlign : 'right'
		,height : 80
		,region : 'south'
		,layout : 'column'
		,labelWidth:50
		,frame : true
		,animate:true
		,items:[
         obj.pnlLast1
		 ,obj.pnlLast2
		 ,obj.pnlLast3
		 ,obj.pnlLast4
		]
		,buttons:[
			obj.btnSave
			,obj.btnPrint
		]
	})
    obj.ViewScreen = new Ext.Viewport({
		 id : 'ViewScreen'
		,layout : 'border'
		,items:[
		obj.pnlBanner
		,obj.pnlMain
		,obj.pnlLast
		       ]
	})
	
	obj.anDoctorStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'FindCtcp';
		param.Arg1 = '';
		param.Arg2 = 'AN^OUTAN^EMAN';
		param.Arg3 = '';
		param.Arg4 = '';
		param.Arg5 = '';
		param.Arg6 = 'Y';
		param.Arg7 = 'N';
		param.ArgCnt = 7;
	});
	obj.anDoctorStore.load()
	
		obj.anNurseStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'FindCtcp';
		param.Arg1 = '';
		param.Arg2 = 'AN^OUTAN^EMAN';
		param.Arg3 = '';
		param.Arg4 = '';
		param.Arg5 = '';
		param.Arg6 = 'N';
		param.Arg7 = 'N';
		param.ArgCnt = 7;
	});
	obj.anNurseStore.load()
    InitViewScreenEvent(obj);
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.btnPrint.on("click",obj.btnPrint_click,obj);
	obj.LoadEvent(arguments);
	return obj;
}