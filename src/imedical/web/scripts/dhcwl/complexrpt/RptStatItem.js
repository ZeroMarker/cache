(function(){
	Ext.ns("dhcwl.complexrpt.RptStatItem");
})();

dhcwl.complexrpt.RptStatItem=function(){
	  var serviceUrl="dhcwl/complexrpt/statitemservice.csp";
      var kpiObj=null;  
      //复选框
      var selectedKpiIds=[];
      var csm=new Ext.grid.CheckboxSelectionModel({
		listeners :{
			rowselect: function(sm, row, rec) {
				var rd=rec;   //sm.getSelected();
				var statId=rec.get("statId");
			 	statForm.getForm().loadRecord(rec);
				statFlagCombo.setRawValue(rd.get('statFlag'));
				statTypeCombo.setRawValue(rd.get('statType'));
			 	statSortCombo.setRawValue(rd.get('statSort'));
				statDimCombo.setValue(rd.get('statDimDr'));
				statWLCombo.setValue(rd.get('statWorkLoad'));
				if(statTypeCombo.getRawValue()=="统计内容") statDimCombo.setDisabled(true);
				else  statDimCombo.setDisabled(false);
				if(!statWLCombo.getValue())textfield.setDisabled(false);
				else  textfield.setDisabled(true);
				if(!textfield.getValue()) statWLCombo.setDisabled(false);
				else  statWLCombo.setDisabled(true);
			},
            'rowdeselect':function(sm, row, rec){
				var statId=rec.get("statId"),len=selectedKpiIds.length;
				for(var i=0;i<len;i++){
					if(selectedKpiIds[i]==statId){
						for(var j=i;j<len;j++){
							selectedKpiIds[j]=selectedKpiIds[j+1]
						}
						selectedKpiIds.length=len-1;
						break;
					}
				}
			}
		}
	});
            
            //定义列
	var columnModel = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),csm,
        {header:'ID',dataIndex:'statId',sortable:true, width: 50, sortable: true
        },{header:'代码',dataIndex:'statCode', width: 100, sortable: true 
        },{header:'描述',dataIndex:'statDesc', width: 120, sortable: true 
        },{header:'执行代码',dataIndex:'statExcCode',width:250
        },{header:'类型',dataIndex:'statType', width: 80, sortable: true
        },{header:'WL字段值',dataIndex:'statWLDesc',resizable:'true',width:140,menuDisabled : true
        },{header:'关联维度',dataIndex:'statDimDesc',resizable:'true',width:120,menuDisabled : true
        },{header:'有效标识',dataIndex:'statFlag',width:60
        },{header:'分类标识',dataIndex:'statSort',width:70
        },{header:'创建日期',dataIndex:'statUpDateDate', width: 100
        }
    ]);
           //定义统计项的存储模型
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSearch'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'statId'},
            	{name: 'statCode'},
            	{name: 'statDesc'},
            	{name: 'statExcCode'},
            	{name: 'statType'},
            	{name: 'statWorkLoad'},
            	{name: 'statDimDr'},
				{name: 'statFlag'},
				{name: 'statUpDateDate'},
				{name: 'statWLDesc'},
				{name: 'statDimDesc'},
				{name: 'statSort'}
       		]
    	})
    });
    //start
    var record= Ext.data.Record.create([
        {name: 'statId', type: 'int'},
        {name: 'statCode', type: 'string'},
        {name: 'statDesc', type: 'string'},
        {name: 'statExcCode',type: 'string'},
        {name: 'statType',type: 'string'},
        {name: 'statWorkLoad',type: 'string'},
        {name: 'statDimDr',type: 'string'},
		{name: 'statFlag',type: 'string'},
		{name: 'statSort',type: 'string'},
        {name: 'statUpDateDate', type: 'string'}
	]);
	

	//end
    //分页控件
    var pageTool=new Ext.PagingToolbar({
        pageSize: 20,
        store: store,
        displayInfo: true,
        displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
        emptyMsg: "没有记录",
        listeners :{
			'change':function(pt,page){
				var id="",j=0,found=false,storeLen=selectedKpiIds.length;
				for(var i=store.getCount()-1;i>-1;i--){
					id=store.getAt(i).get("statId");
					found=false;
					for(j=storeLen-1;j>-1;j--){
						if(selectedKpiIds[j]==id) found=true;
					}
					if(found){
						csm.selectRow(i,true,false);
					}
				}
			}
		}
    });
    
            //列表
            var grid = new Ext.grid.GridPanel({
	            id:"StatTables",
                sm: csm,
                resizeAble:true,
                loadMask:true,
                enableColumnResize :true,
                //title: '列表标题',
                height: 420,
                store: store,
                //tbar: [tbtn], //顶部工具栏
                bbar: pageTool,  //底部工具栏
                //colModel: columnModel
                cm: columnModel,
                listeners:{
        			'contextmenu':function(event){
        			event.preventDefault();
        			var sm = this.getSelectionModel();
        			var record = sm.getSelected();
        			if(record){
                	var record = sm.getSelected();
        			}  
        		}
        }          
     });
     
     
     var statFlagCombo=new Ext.form.ComboBox({
		width : 120,
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		fieldLabel : '是否有效',
		value:'Y',
		name : 'statFlagCombo',
		displayField : 'mFlag',
		valueField : 'mFlagV',
		store : new Ext.data.JsonStore({
			fields : ['mFlag', 'mFlagV'],
			data : [{
				mFlag : '是',
				mFlagV : 'Y'
			}, {
				mFlag : '否',
				mFlagV : 'N'
			}]})
	});
	
	var statTypeCombo=new Ext.form.ComboBox({
		width : 100,
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		fieldLabel : '类型',
		value:'S',
		name : 'statTypeCombo',
		displayField : 'mType',
		valueField : 'mTypeV',
		store : new Ext.data.JsonStore({
			fields : ['mType', 'mTypeV'],
			data : [{
				mType : '统计项',
				mTypeV : 'S'
			}, {
				mType : '统计内容',
				mTypeV : 'C'
			}]}),
		listeners :{
			'select':function(combox){
				statTypeCombo.setValue(combox.getValue());
				//Ext.getCmp('modeFlagCombo').setValue(combox.getValue());
				if(statTypeCombo.getValue()=="C"){
					statDimCombo.setDisabled(true);
				}else{
					statDimCombo.setDisabled(false);
				}
			}
		}
	});
	
	var statSortCombo=new Ext.form.ComboBox({
		width : 120,
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all', //显示所有下拉数据
		fieldLabel : '统计项分类',
		value:'stat', //默认值
		name : 'statSortCombo',
		displayField : 'mSort',
		valueField : 'mSortV',
		store : new Ext.data.JsonStore({
			fields : ['mSort', 'mSortV'],
			data : [{
				mSort : '统计项',
				mSortV : 'stat'
			}, {
				mSort : '列表项',
				mSortV : 'list'
			}]})
	});
	
	var statWLCombo=new Ext.form.ComboBox({
		width : 180,
		editable:true,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		fieldLabel : 'WL字段值',
		typeAhead : true,
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:16px;">' +   
			'{statWLName}' +   
			'</div>'+   
			'</tpl>',
		emptyText:'请选择WL字段',
		name : 'statWLCombo',
		displayField : 'statWLName',
		valueField : 'statWLCode',
		enableKeyEvents : true,
		//forceSelection : true,
		selectOnFocus : true,
		store : new Ext.data.Store({
			autoLoad : true,
			proxy:new Ext.data.HttpProxy({url:'dhcwl/complexrpt/rptcfgservice.csp?action=getStatWLCombo&wlFilter='}),
			reader:new Ext.data.ArrayReader({},[{name:'statWLCode'},{name:'statWLName'}])
		}),
		listeners :{
			'select':function(combox){
				statWLCombo.setValue(combox.getRawValue());
				if(!statWLCombo.getValue()){
					textfield.setDisabled(false);
				}else{
					textfield.setDisabled(true);
				}
			},
			'specialkey' : function(obj, e) {
				var wlFilter = obj.getRawValue();
				obj.store.proxy.conn.url = encodeURI('dhcwl/complexrpt/rptcfgservice.csp?action=getStatWLCombo&wlFilter='+wlFilter);
				obj.store.load({});
			}
		}
	});


	var statDimCombo=new Ext.form.ComboBox({
		width : 160,
		editable:true,
		//minChars:1,
		typeAhead : true,
		xtype : 'combo',
		mode : 'remote',
		//mode : 'local',
		triggerAction : 'all',
		fieldLabel : '关联维度',
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:16px;">' +   
			'{statDimName}' +   
			'</div>'+   
			'</tpl>',
		emptyText:'请选择关联维度',
		name : 'statDimCombo',
		displayField : 'statDimName',
		valueField : 'statDimCode',
		enableKeyEvents : true,
		//selectOnFocus : true,
		//forceSelection : true,
		store : new Ext.data.Store({
			autoLoad : true,
			//url:'dhcwl/complexrpt/rptcfgservice.csp?action=getStatDimCombo&dimDesc=',
			proxy:new Ext.data.HttpProxy({url:'dhcwl/complexrpt/rptcfgservice.csp?action=getStatDimCombo&dimDesc='}),
			reader:new Ext.data.ArrayReader({},[{name:'statDimCode'},{name:'statDimName'}])
		}),
		listeners :{
			'select':function(combox){
				statDimCombo.setValue(combox.getRawValue());	
			},/*
        	'beforequery' : function(e){
      			var combo = e.combo;
      			//combo.store.load({});
            	if(!e.forceAll){
             		var input = e.query;
             		var regExp = new RegExp(".*" + input + ".*");
                	combo.store.filterBy(function(record,id){
                		var text = record.get(combo.displayField);
                		//return (text.indexOf(input)!=-1);
                		return regExp.test(text);
                	});
                	combo.expand();
                	return false;
                }
     		},
     		'focus' : function() {
				this.store.on('beforeload', function() {
					var sDimDesc = statDimCombo.getRawValue();
					this.proxy.conn.url = encodeURI('dhcwl/complexrpt/rptcfgservice.csp?action=getStatDimCombo&dimDesc='+sDimDesc);
				});
				this.store.load({});
			},*/
			'specialkey' : function(obj, e) {
				var sDimDesc = obj.getRawValue();
				obj.store.proxy.conn.url = encodeURI('dhcwl/complexrpt/rptcfgservice.csp?action=getStatDimCombo&dimDesc='+sDimDesc);
				obj.store.load({});
			}
		}
	});

	// 执行代码输入框
	var textfield=new Ext.form.TextField({
		xtype:'textfield',
		fieldLabel : '执行代码',
        name: 'statExcCode',
        id: 'statExcCode',
        colspan: 2,
        width:321,
		listeners :{
			'blur':function(field){
				if(!textfield.getValue()){
					statWLCombo.setDisabled(false);
				}else{
					statWLCombo.setDisabled(true);
				}	
			}
		}
	});
	
	//表单
	var statForm=new Ext.FormPanel({
    	height: 130,
        frame: true,
       	labelAlign: 'right',
        autoScroll:true,
        bodyStyle:'padding:5px',
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        items : [{
					layout : 'column',
					items : [{
						labelWidth : 40,
						columnWidth : .15,
						layout : 'form',
						defaultType : 'textfield',
						defaults : {
							width : 110
						},
						items : [{
									fieldLabel : 'ID',
									id : 'statId',
									name : 'statId',
									disabled : true
								}, statTypeCombo]
					}, {
						labelWidth : 60,
						columnWidth : .22,
						layout : 'form',
						// defaultType : 'textfield',
						defaults : {
							width : 160
						},
						items : [{
									fieldLabel : '代码',
									xtype : 'textfield',
									id : 'statCode',
									name : 'statCode'
								}, statDimCombo]
					}, {
						labelWidth : 60,
						columnWidth : .17,
						layout : 'form',
						defaults : {
							width : 120
						},
						items : [{
									xtype : 'textfield',
									fieldLabel : '描述',
									id : 'statDesc',
									name : 'statDesc'
								}, statFlagCombo]
					}, {
						labelWidth : 70,
						columnWidth : .27,
						layout : 'form',
						defaults : {
							width : 200
						},
						items : [textfield,statWLCombo]
					}, {
						labelWidth : 75,
						columnWidth : .17,
						layout : 'form',
						defaults : {
							width : 100
						},
						items : [statSortCombo]
					}]

				}],
         tbar: new Ext.Toolbar([{
            text: '<span style="line-Height:1">增加</span>',
            icon   : '../images/uiimages/edit_add.png',
            handler: function(){
            	var cursor=Math.ceil((pageTool.cursor + pageTool.pageSize) / pageTool.pageSize);
				var form=statForm.getForm();
          		var values=form.getValues(false);
          		var statCode=Ext.get('statCode').getValue();
          		var reg=/[\$\#\@\&\%\!\*\^\~||]/;
                var reg2=/^\d/;
                if(reg.test(statCode)||(reg2.test(statCode))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符，并且不能以数字开头！");
                	Ext.get("statCode").focus();
                	return;
                }
           		var statCode=Ext.get('statCode').getValue();
           		var statDesc=Ext.get('statDesc').getValue();
           		var statExcCode=Ext.get('statExcCode').getValue();
           		var statFlag=statFlagCombo.getRawValue();
           		var statType=statTypeCombo.getRawValue();
           		var statDimDr=statDimCombo.getValue();
           		var statWorkLoad=statWLCombo.getValue();
           		var statSort=statSortCombo.getRawValue();
           		if(!statCode||!statDesc){
                	alert("统计项编码、描述不能为空！");
                	return;
                }
                if(!statWorkLoad&&!statExcCode){
                	alert("WL字段值和执行代码不能同时为空！");
                	return;
                }
                if(statWorkLoad&&statExcCode){
                	alert("WL字段值和执行代码必须有一个为空！");
                	return;
                }
                if(!statFlag||statFlag==""||statFlag=='否'||statFlag=='N') statFlag='N';
                else statFlag='Y';
                if(!statType||statType==""||statType=='统计内容'||statType=='C') statType='C';
                else statType='S';
                if(!statSort||statSort==""||statSort=='统计项'||statSort=='stat') statSort='stat';
                else statSort='list';
           		paraValues='statCode='+statCode+'&statDesc='+statDesc+'&statType='+statType+'&statExcCode='+statExcCode+'&statDimDr='+statDimDr+'&statWorkLoad='+statWorkLoad+'&statFlag='+statFlag+'&statSort='+statSort;             
           		dhcwl.complexrpt.Util.ajaxExc(serviceUrl+'?action=addStat&'+paraValues);
           		store.load();
           		pageTool.cursor=0;
                pageTool.doLoad(pageTool.pageSize*(cursor-1));
           		//grid.show();	
            }
        },'-',{
        	cls:'align:right',
        	text: '<span style="line-Height:1">更新</span>',
        	icon   : '../images/uiimages/update.png',
            handler: function() {
            	var cursor=Math.ceil((pageTool.cursor + pageTool.pageSize) / pageTool.pageSize);
                var paraValues; //=form.getValues(true);此方法会出现乱码
                var sm = grid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
                	alert("请选择要更新的统计项");
                	return;
                }
                var statId=record.get("statId");
                //var statId=Ext.get("statId").getValue();
                var statCode=Ext.get('statCode').getValue();
           		var statDesc=Ext.get('statDesc').getValue();
           		var statExcCode=Ext.get('statExcCode').getValue();
           		var statFlag=statFlagCombo.getRawValue();
           		var statType=statTypeCombo.getRawValue();
           		var statDimDr=statDimCombo.getValue();
           		var statWorkLoad=statWLCombo.getValue();
           		var statSort=statSortCombo.getRawValue();
           		if(!statFlag||statFlag==""||statFlag=='否'||statFlag=='N') statFlag='N';
                else statFlag='Y';
                if(!statType||statType==""||statType=='统计内容'||statType=='C') statType='C';
                else statType='S';
                if(!statSort||statSort==""||statSort=='统计项'||statSort=='stat') statSort='stat';
                else statSort='list';
                var reg=/[\$\#\@\&\%\!\*\^\~||]/;
                var reg2=/^\d/;
                if(reg.test(statCode)||(reg2.test(statCode))){
                	alert("统计项代码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符?并且不能以数字开头");
                	Ext.get("statCode").focus(); //控制光标的焦点
                	return;
                }
                if(statCode) statCode=statCode.trim(); //截掉代码左右空格
                if(!statCode||!statDesc){
                	alert("统计项编码、描述不能为空!");
                	return;
                }
              	if(!statWorkLoad&&!statExcCode){
                	alert("WL字段值和执行代码不能同时为空！");
                	return;
                }
                if(statWorkLoad&&statExcCode){
                	alert("WL字段值和执行代码必须有一个为空！");
                	return;
                }
                paraValues='statId='+statId+'&statCode='+statCode+'&statDesc='+statDesc+'&statType='+statType+'&statExcCode='+statExcCode+'&statDimDr='+statDimDr+'&statWorkLoad='+statWorkLoad+'&statFlag='+statFlag+'&statSort='+statSort;
                dhcwl.complexrpt.Util.ajaxExc(serviceUrl+'?action=updateStat&'+paraValues);
                store.load();
                pageTool.cursor=0;
                pageTool.doLoad(pageTool.pageSize*(cursor-1));   
           }
        },'-',{text: '<span style="line-Height:1">清空</span>',
        	icon   : '../images/uiimages/clearscreen.png',
        	cls:'align:right',
            handler: function() {
            	var form=statForm.getForm();
            	statDimCombo.setDisabled(false);
            	statWLCombo.setDisabled(false);
            	textfield.setDisabled(false);
    			form.setValues({statId:'',statCode:'',statDesc:'',statExcCode:'',statTypeCombo:'',statWLCombo:'',statFlagCombo:'',statDimCombo:'',statSortCombo:''});
        	}
        },'-',{text: '<span style="line-Height:1">查询</span>',
        	icon   : '../images/uiimages/search.png',
        	cls:'align:right',
            handler: function() {
            	var statId=Ext.get("statId");
                var statCode=Ext.get('statCode').getValue();
           		var statDesc=Ext.get('statDesc').getValue();
           		var statExcCode=Ext.get('statExcCode').getValue();
           		var statFlag=statFlagCombo.getValue();
           		var statType=statTypeCombo.getValue();
           		var statDimDr=statDimCombo.getValue();
           		var statSort=statSortCombo.getValue();
           		var statWorkLoad=statWLCombo.getValue(); // getValue(): 真实值, getRawValue(): 显示值
           		//var statDimDr=statDimCombo.getRawValue();
           		//var statWorkLoad=statWLCombo.getRawValue();
                paraValues='statCode='+statCode+'&statDesc='+statDesc+'&statType='+statType+'&statExcCode='+statExcCode;
                paraValues=paraValues+'&statDimDr='+statDimDr+'&statWorkLoad='+statWorkLoad+'&statFlag='+statFlag+'&statSort='+statSort;
                store.proxy.setUrl(encodeURI(serviceUrl+'?action=mulSearch&'+paraValues+'&onePage=1'));
            	store.load({params:{start:0,limit:20}});
           }
        }
      ])
	});
            
   var statShowWin =new Ext.Panel({
    	title:'统计项与统计内容维护',
    	layout:'auto',
        items: [{
        	region: 'north',
            //height: 148,
            //autoScroll:true,
            items:statForm
        },{
        	region:'center',
        	//autoScroll:true,
            items:grid
    	}]
    	
    });
    
    store.load({params:{start:0,limit:20,onePage:1}});

	this.getStore=function(){
    	return store;
    }
    this.getColumnModel=function(){
    	return columnModel;
    }
    this.getStatShowWin=function(){
    	//kpiGrid.setHeight(kpiShowWin.getHeight()-158);
    	return statShowWin;
    }
    this.getStatForm=function(){
    	return statForm;
    }
    this.getMcGrid=function(){
    	return grid;
    }
    this.getRecord=function(){
    	return record;
    }
    this.refreshCombo=function(){
    	statWLCombo.getStore().proxy.setUrl(encodeURI('dhcwl/complexrpt/rptcfgservice.csp?action=getStatWLCombo'));
    	statWLCombo.getStore().load();
    	statWLCombo.show();
    	StatDimCombo.getStore().proxy.setUrl(encodeURI('dhcwl/complexrpt/rptcfgservice.csp?action=getStatDimCombo'));
    	StatDimCombo.getStore().load();
    	StatDimCombo.show();
    }
}