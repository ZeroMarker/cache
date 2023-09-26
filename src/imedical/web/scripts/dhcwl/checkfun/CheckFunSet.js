(function(){
	Ext.ns("dhcwl.checkfun.CheckFunSet");
})();

 //
dhcwl.checkfun.CheckFunSet=function(){
	var ObjTypeDim=null;
	var serviceUrl="dhcwl/checkfun/checkfunservice.csp";
	var outThis=this;
	var checkfunValues=null;
	var checkfunRel=null;
	var curStart=0,curLimit=0;
	var setRecordId="";
	var quickMenu=new Ext.menu.Menu({
		boxMinWidth:180,
		ignoreParentClicks:true,
		items:[
			{
				text:'维护考核方案和考核指标',
				handler:function(cmp,event){
					var sm=CheckFunSetGrid.getSelectionModel();
					if(!sm){
						alert("请选择一行!");
						return;
					}
					var record=sm.getSelected();
					if(!record){
						alert("请选择一行");
						return;
					}
					var setRecordId=record.get('ID');
					var setName=record.get('CheckSetDesc')
					/*if (checkfunRel==null){
						checkfunRel=new dhcwl.checkfun.CheckFunRel(setRecordId,setName);
					}*/
					checkfunRel=new dhcwl.checkfun.CheckFunRel(setRecordId,setName);
					checkfunRel.setSubWinParam(setRecordId,setName);
					checkfunRel.showWin(outThis);
				}
			},'-',{
				text:'进入考核方案标准值界面',
				handler:function(cmp,event){
				var sm = CheckFunSetGrid.getSelectionModel();
				if(!sm){
				alert("请选择一行!");
				return;}
				var record=sm.getSelected();
				if(!record){
				alert("请选择一行!");
				return;}
				
				var setRecordId=record.get('ID');
				var setName=record.get('CheckSetDesc');
				var setObjType=record.get('CheckSetObjType')
				/*if (checkfunValues==null){
					checkfunValues=new dhcwl.checkfun.CheckFunValue(setRecordId,setName);
					}
					*/
				checkfunValues=new dhcwl.checkfun.CheckFunValue(setRecordId,setName,setObjType);	
				checkfunValues.setSubWinParam(setRecordId,setName);	
				checkfunValues.showWin(outThis);
				
				}
			}
		]
	})
	////end
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: true},
        {header:'方案编码',dataIndex:'CheckSetCode',sortable:true, width: 100, sortable: true},
        {header:'方案描述',dataIndex:'CheckSetDesc', width: 100, sortable: true},
        {header:'区间类型',dataIndex:'CheckSetSectionType', width: 160, sortable: true},
        {header:'对象类型',dataIndex:'CheckSetObjType', width: 160, sortable: true},
        {header:'对象ID',dataIndex:'CheckSetObjId', width: 160, sortable: true,hidden:true},
        {header:'对象属性',dataIndex:'CheckSetObjDim', width: 160, sortable: true},
        {header:'属性ID',dataIndex:'CheckSetDimId', width: 160, sortable: true,hidden:true},
        {header:'考核指标维护',dataIndex:'CheckSetKpi',width:160,sortable:true},
        {header:'更新日期',dataIndex:'CheckSetUpdateDate', width: 160, sortable: true},
        {header:'更新用户',dataIndex:'CheckSetUpdateUser', width: 100, sortable: true}      //,renderer:formateDate
    ]);

    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSearchSet&className=DHCWL.CheckFun.CheckSet&start=0&limit=21&onePage=1'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'CheckSetCode'},
            	{name: 'CheckSetDesc'},
            	{name: 'CheckSetSectionType'},
            	{name: 'CheckSetObjType'},
            	{name: 'CheckSetObjDim'},
            	{name:'CheckSetKpi'},
            	{name: 'CheckSetUpdateDate'},
            	{name: 'CheckSetUpdateUser'},
            	{name:'CheckSetObjId'},
            	{name:'CheckSetDimId'}
            
       		]
    	})
    });
    //store.load()
    //store.load({params:{start:0,limit:21}});
    /*
    var myData = [
        ['1','分类编码1','分类描述1','执行代码1','值描述1','有效标志1','更新日期1'],
        ['2','分类编码2','分类描述1','执行代码1','值描述1','有效标志1','更新日期1'],
        ['3','分类编码3','分类描述1','执行代码1','值描述1','有效标志1','更新日期1'],
        ['4','分类编码4','分类描述1','执行代码1','值描述1','有效标志1','更新日期1'],
        ['5','分类编码5','分类描述1','执行代码1','值描述1','有效标志1','更新日期1']
    ];
    

   // create the data store
    var store = new Ext.data.ArrayStore({
        fields: [
           {name: 'ID'},
           {name: 'TypeCode'},
           {name: 'TypeDesc'},
           {name: 'TypeExtCode'},
           {name: 'TypeValueDes'},
           {name: 'TypeFlag'},
           {name: 'TypeCreateDate'}
     
        ]
    });

    // manually load local data
    store.loadData(myData);
    */
    
    var CheckFunSetGrid = new Ext.grid.GridPanel({
        stripeRows:true,
        loadMask:true,
        //height:540,
        store: store,
        cm: columnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	rowselect: function(sm, row, rec) {
            		var id=rec.get("ID");
            		var form=CheckFunSetForm.getForm();
                	form.loadRecord(rec);
                	form.setValues({ID:id});
                	if(id!=""){
                		form.findField("CheckSetObjType").disable();
                		form.findField("CheckSetObjDim").disable();
                		form.findField("CheckSetObjId").disable();
                		form.findField("CheckSetDimId").disable();
                	}else{
                		form.findField("CheckSetObjType").enable();
                		form.findField("CheckSetObjDim").enable();
                		form.findField("CheckSetObjId").enable();
                		form.findField("CheckSetDimId").enable();
                	}
                	
             	}
            }
        }),
        listeners:{
        	'contextmenu':function(event){
        		event.preventDefault();
        		quickMenu.showAt(event.getXY());
        	}
        }
         ,
        bbar:new Ext.PagingToolbar({
            pageSize: 21,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            listeners:{
            	'beforechange':function(pt,params){
            		curStart=params.start;
            		curLimit=params.limit;
            	}
            }
        }),
        tbar: new Ext.Toolbar([
        ])
        /**/
    });
   
    
    var setSectionCombo=new Ext.form.ComboBox({
		//width : 130,
		anchor:'80%',
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		fieldLabel : '区间类型',
		value:'',
		name : 'setSectionCombo',
		id:  'CheckSetSectionType',
		displayField : 'isValid',
		valueField : 'isValidV',
		tpl:'<tpl for=".">'+'<div class="x-combo-list-item" style="height:15px;">'+'{isValid}'+'</div>'+'</tpl>',
		store : new Ext.data.JsonStore({
			fields : ['isValid', 'isValidV'],
			data : [{
				isValid : '',
				isValidV : ''
			},{
				isValid : '日',
				isValidV : '日'
			},{
				isValid : '月',
				isValidV : '月'
			},
			{
				isValid : '季',
				isValidV : '季'
			}, 
			{
				isValid : '年',
				isValidV : '年'
			}]}),
		listeners :{
			'select':function(combox){
				setSectionCombo.setValue(combox.getValue());
			}
		}
	});
	var setObjTypeCombo=new Ext.form.ComboBox({
			width:130,
			editable:false,
			xtype:'combo',
			mode:'remote',
			triggerAction:'all',
			emptyText:'请选择考核对象类型',
			name:'setObjTypeCombo',
			id:'CheckSetObjType',
			displayField:'TypeDesc',
			valueField:'TypeCode',
			store:new Ext.data.Store({
				proxy:new Ext.data.HttpProxy({url:'dhcwl/checkfun/checkfunservice.csp?action=getObjTypeCombo'}),
				reader:new Ext.data.ArrayReader({},[{name:'TypeCode'},{name:'TypeDesc'}])
				
			}),
			listeners:{
				'select':function(combox){
				setObjTypeCombo.setValue(combox.getRawValue());
				
				}
			}
		});
    var CheckFunSetForm = new Ext.FormPanel({
        frame: true,
        //height: 102,
		
		labelAlign : 'right',
		labelWidth : 65,
		bodyStyle : 'padding:5px',
		style : {
			"margin-right" : Ext.isIE6 ? (Ext.isStrict
					? "-10px"
					: "-13px") : "0"
		},
		
		layout : 'column',
		items:[
		{
			columnWidth : .3,
			layout : 'form',
			defaultType : 'textfield',

			items : [{
				fieldLabel : 'ID',
				name: 'ID',
				disabled:true,
				anchor:'80%'				
			},setSectionCombo,
        {
        	xtype:'textfield',
        	width:30,
        	name:'CheckSetDimId',
        	id:'CheckSetDimId',
        	disabled:true,
        	hidden:true
        }]
		},{
			columnWidth : .3,
			layout : 'form',
			defaultType : 'textfield',
			items : [{
				fieldLabel : '方案编码',
				xtype:'textfield',
				name: 'CheckSetCode',
				id: 'CheckSetCode',
				anchor:'80%'						
			},{
				fieldLabel : '对象类型',
				xtype:'compositefield',
				anchor:'80%',
			
				items:[{
					name:'CheckSetObjType',
					id:'CheckSetObjType',
					xtype:'textfield',
					disabled:true,
					flex:7
				},{
					name:'showObjType',
					id:'showObjType',
					xtype:'button',
					//anchor:'100%',
					handler:OnShowObjType,
					icon   : '../images/uiimages/search.png',
					flex:1

					//width:35							
				}]						
			},{
				width:30,
				name:'CheckSetObjId',
				id:'CheckSetObjId',
				xtype:'textfield',
				anchor:'80%',
				disabled:true,
				hidden:true
			}
		]
		},{
			columnWidth : .3,
			layout : 'form',
			defaultType : 'textfield',
			items : [{
				fieldLabel : '方案描述',
				name: 'CheckSetDesc',
				id: 'CheckSetDesc',
				xtype:'textfield',
				anchor : '80%'				
			},{
				fieldLabel : '对象属性',
				name:'CheckSetObjDim',
				id:'CheckSetObjDim',
				disabled:true,
				anchor : '80%'				
			}]
		}],				
         tbar:new Ext.Toolbar([
         	{text: '<span style="line-Height:1">增加</span>',
icon   : '../images/uiimages/edit_add.png',
         	 handler: function() {
            	var form=CheckFunSetForm.getForm();
                var values=form.getValues(false);
                var SetCode=Ext.get('CheckSetCode').getValue();
                var reg=/[\$\#\@\&\%\!\*\^\~||]/;
                var reg2=/^\d/;
                if(reg.test(SetCode)||(reg2.test(SetCode))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符，并且不能以数字开头！");
                	Ext.get("CheckSetCode").focus();
                	return;
                }
                
                var SetDesc=Ext.get('CheckSetDesc').getValue();
                var SetSecType=setSectionCombo.getValue();
                //var SetObjType=setObjTypeCombo.getRawValue();
                var SetObjType=Ext.get('CheckSetObjType').getValue();
                var SetObjId=Ext.get('CheckSetObjId').getValue();
                var SetObjDim=Ext.get('CheckSetObjDim').getValue();
                var SetDimId=Ext.get('CheckSetDimId').getValue();
                if((!SetCode)||(!SetDesc)||(!SetSecType)||(!SetObjId)){
							alert("方案编码或者方案描述或者对象类型或者区间类型不能为空!");
							return;
							}
                var SetUpdateUser="";
                paraValues='SetCode='+SetCode+'&SetDesc='+SetDesc+'&SetSecType='+SetSecType+'&SetObjType='+SetObjId+'&SetObjDim='+SetDimId+'&SetUpdateUser='+SetUpdateUser;
                //alert(paraValues);
                
                var url=serviceUrl+'?action=addCheckFunSet&'+paraValues;
                dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
                	if(jsonData.success==true&&jsonData.tip=="ok"&&jsonData.ROWID!=null&&jsonData.ROWID!=""){
                	var	setId=jsonData.ROWID;
                	var setName=jsonData.name;
                	//var setName="";
                	//alert(setId);
                	checkfunRel=new dhcwl.checkfun.CheckFunRel(setId,setName);
					checkfunRel.setSubWinParam(setId,setName);
					checkfunRel.showWin(outThis);
                	
                	}
                	else{
                	 Ext.Msg.show({
               							title: '处理失败',
										msg:'方案代码不能重复',
										buttons: Ext.MessageBox.OK,
										icon: Ext.MessageBox.INFO

               					});
                	}
                	
                } ,this); 
            	store.load();
    			CheckFunSetGrid.show();
         	
                } 
            },'-',
         	{text: '<span style="line-Height:1">更新</span>',
icon   : '../images/uiimages/update.png',	
         	 handler:function(){
         	 	var form=CheckFunSetForm.getForm();
                var values=form.getValues(false);
         	 	var sm = CheckFunSetGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
               		alert("请选择要更新的行！");
               		return;}
         	 	Ext.Msg.confirm('信息', '确定要更新', function(btn){
                    if (btn == 'yes') {
                        var ID=record.get("ID");
                        var SetCode=Ext.get('CheckSetCode').getValue();
					 	var SetDesc=Ext.get('CheckSetDesc').getValue();
					 	var SetSecType=setSectionCombo.getValue();
                        //var SetObjType=setObjTypeCombo.getRawValue();
					 	var SetObjType=Ext.get('CheckSetObjId').getValue();
                		var SetObjDim=Ext.get('CheckSetDimId').getValue();
						var SetUpdateUser="";
						//alert (SetObjType);
                		if((!SetDesc)||(!SetCode)||(!SetSecType)||(!SetObjType)||(!SetObjDim)){
									alert("方案描述或者方案编码或者区间类型或者对象类型或者对象属性不能为空!");
									return;
								}
                		paraValues='ID='+ID+'&SetCode='+SetCode+'&SetDesc='+SetDesc+'&SetSecType='+SetSecType+'&SetObjType='+SetObjType+'&SetObjDim='+SetObjDim+'&SetUpdateUser='+SetUpdateUser;
                        //alert(paraValues);
                		dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=updateCheckFunSet&'+paraValues);
                		store.load();
                		
                		//dhcwl_codecfg_showKpiWin.refreshCombo();
                		}
                	});
         	 }
         	
         	},'-',
         	{text: '<span style="line-Height:1">删除</span>',
icon   : '../images/uiimages/edit_remove.png',
             handler: function(){
            	var sm = CheckFunSetGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
               		alert("请选择要删除的行!");
               		return;}
                Ext.Msg.confirm('信息', '删除该方案同时会删除关联的标准值和例外值？', function(btn){
                    if (btn == 'yes') {
                        var ID=record.get("ID");
                        store.remove(record);
                		dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteCheckFunSet&ID='+ID);
                		var form=CheckFunSetForm.getForm();
    			        form.setValues({ID:'',CheckSetCode:'',CheckSetDesc:'',setSectionCombo:'',CheckSetObjType:'',CheckSetObjDim:'',CheckSetDimId:'',CheckSetObjId:''});
                		}
                	});
                }
            },'-',
         	{text: '<span style="line-Height:1">清空</span>',
         	 //disabled : Ext.BDP.FunLib.Component.DisableFlag('clear_btn'),
         	 handler: function() {
            	var form=CheckFunSetForm.getForm();
    			form.setValues({ID:'',CheckSetCode:'',CheckSetDesc:'',setSectionCombo:'',CheckSetObjType:'',CheckSetObjDim:'',CheckSetDimId:'',CheckSetObjId:''});
    			}
         	},'-',
         	{text: '<span style="line-Height:1">查询</span>',
icon   : '../images/uiimages/search.png',		
         	 //disabled : Ext.BDP.FunLib.Component.DisableFlag('search_btn'),
         	 handler: function() {
                            var CheckSetCode=Ext.get('CheckSetCode').getValue();
							var CheckSetDesc=Ext.get('CheckSetDesc').getValue();
						    var CheckSetSectionType=setSectionCombo.getValue();
                            //var CheckSetObjType=setObjTypeCombo.getRawValue();
						    var CheckSetObjType=Ext.get('CheckSetObjId').getValue();
						    var CheckSetObjDim=Ext.get('CheckSetDimId').getValue();  
                            //alert(CheckSetObjType); 
						    paraValues='CheckSetCode='+CheckSetCode+'&CheckSetDesc='+CheckSetDesc+'&CheckSetSectionType='+CheckSetSectionType+'&CheckSetObjType='+CheckSetObjType+'&CheckSetObjDim='+CheckSetObjDim;
						    //alert(paraValues);
						    store.proxy.setUrl(encodeURI(serviceUrl+"?action=mulSearchSet&className=DHCWL.CheckFun.CheckSet&"+paraValues+"&start=0&limit=5&onePage=1"));
						    store.load();
						    CheckFunSetGrid.show();
    			}
         	}
    ])
    });

    
    var CheckFunSetPanel =new Ext.Panel({
    	title:'考核方案',
       	layout:'border',
        items: [{
        	region: 'north',
            height: 125,
            //autoScroll:true,
			layout:'fit',
            items:CheckFunSetForm
        },{
        	region:'center',
        	//autoScroll:true,
			layout:'fit',
            items:CheckFunSetGrid
    	}]
		/*,
    	listeners:{
    		"resize":function(win,width,height){
    			CheckFunSetGrid.setHeight(height-110);
    			CheckFunSetGrid.setWidth(width-15);
    		}
    	}
		*/
    });
    CheckFunSetPanel.on('activate',function(thss){
    store.load({params:{start:0,limit:21}});
    });
    
    this.getCheckFunSetPanel=function(){
    	return CheckFunSetPanel;
    }
    function OnShowObjType(){
    	if(ObjTypeDim==null){
    		ObjTypeDim=new dhcwl.checkfun.CheckFunObjType();
     	}
     	ObjTypeDim.showWin(outThis);
    }
     this.getForm=function(){
    	return CheckFunSetForm;
    }
    this.getSetStore=function(){
    	return store;
    }
}



