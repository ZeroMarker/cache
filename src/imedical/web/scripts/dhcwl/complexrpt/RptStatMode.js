(function(){
	Ext.ns("dhcwl.complexrpt.RptStatMode");
})();

dhcwl.complexrpt.RptStatMode=function(){
	  var serviceUrl="dhcwl/complexrpt/statmodeservice.csp";
      var kpiObj=null;  
      //复选框
      var selectedKpiIds=[];
      var csm=new Ext.grid.CheckboxSelectionModel({
	      listeners :{
		      rowselect: function(sm, row, rec) {
			      var rd=rec;   //sm.getSelected();
			      var modeId=rec.get("modeId");
			      modeFlagCombo.setRawValue(rd.get('modeFlag')); 
			      modeForm.getForm().loadRecord(rec);
			  },
            'rowdeselect':function(sm, row, rec){
				var modeId=rec.get("modeId"),len=selectedKpiIds.length;
				for(var i=0;i<len;i++){
					if(selectedKpiIds[i]==modeId){
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
        {header:'ID',dataIndex:'modeId',sortable:true, width: 70, sortable: true ,menuDisabled : true
        },{header:'代码',dataIndex:'modeCode', width: 150, sortable: true ,menuDisabled : true 
        },{header:'描述',dataIndex:'modeDesc', width: 150, sortable: true ,menuDisabled : true 
        },{header:'执行代码',dataIndex:'modeExcCode', width: 330, sortable: true ,menuDisabled : true
        },{header:'有效标示',dataIndex:'modeFlag', width: 130, sortable: true ,menuDisabled : true
        }
    ]);
           //定义统计模式的存储模型
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSearch'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'modeId'},
            	{name: 'modeCode'},
            	{name: 'modeDesc'},
            	{name: 'modeExcCode'},
            	{name: 'modeFlag'}
       		]
    	})
    });
    //start
    var record= Ext.data.Record.create([
        {name: 'modeId', type: 'int'},
        {name: 'modeCode', type: 'string'},
        {name: 'modeDesc', type: 'string'},
        {name: 'modeExcCode',type: 'string'},
        {name: 'modeFlag',type: 'string'}
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
					id=store.getAt(i).get("modeId");
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
	            id:"modeTables",
                sm: csm,
                resizeAble:true,
                loadMask:true,
                enableColumnResize :true,
                //title: '列表标题',
                height: 454,
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
     
     var modeFlagCombo=new Ext.form.ComboBox({
		width : 100,
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		fieldLabel : '是否有效',
		value:'Y',
		name : 'modeFlagCombo',
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
			}]}),
		listeners :{
			'select':function(combox){
				modeFlagCombo.setValue(combox.getValue());
				//Ext.getCmp('modeFlagCombo').setValue(combox.getValue());
			}
		}
	});
        //表单
        var modeForm=new Ext.FormPanel({
        //id: 'kpi-list',
    	height: 100,
        frame: true,
        autoScroll:true,
        labelAlign: 'left',
        bodyStyle:'padding:5px',
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        //defaultConfig:{width:110},
        layout: 'table',
        layoutConfig: {columns:20},
        items:[{
        	html: 'ID：'
        },{
            disabled:true,
        	editable:false,
            xtype:'textfield',
            name: 'modeId',
            id:'modeId',
            //anchor:'95%',
            width:80
        },{
            html: '&nbsp&nbsp&nbsp代码：'
        },{
            name: 'modeCode',
            id:'modeCode',
            xtype:'textfield',
            //anchor:'95%',
            width:100
            //validator:dhcwl.mkpi.Util.valideValue
        },{
            html: '&nbsp&nbsp&nbsp描述：'
        },{
            name: 'modeDesc',
            id:'modeDesc',
            xtype:'textfield',
            //anchor:'95%',
            colspan:6,
            width:170
        },{
            html: '&nbsp&nbsp&nbsp有效标示：'
        },modeFlagCombo,{
            html: '&nbsp&nbsp&nbsp执行代码：'
        },{
        	xtype:'textfield',
            name: 'modeExcCode',
            id: 'modeExcCode',
            colspan:6,
            width:300
         }],
         tbar: new Ext.Toolbar([{
            text: '<span style="line-Height:1">增加</span>',
            icon   : '../images/uiimages/edit_add.png',
            handler: function(){
				var form=modeForm.getForm();
          		var values=form.getValues(false);
          		var modeCode=Ext.get('modeCode').getValue();
          		var reg=/[\$\#\@\&\%\!\*\^\~||]/;
                var reg2=/^\d/;
                if(reg.test(modeCode)||(reg2.test(modeCode))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符，并且不能以数字开头！");
                	Ext.get("modeCode").focus();
                	return;
                }
           		var modeCode=Ext.get('modeCode').getValue();
           		var modeDesc=Ext.get('modeDesc').getValue();
           		var modeExcCode=Ext.get('modeExcCode').getValue();
           		var modeFlag=modeFlagCombo.getRawValue();
           		if(!modeFlag||modeFlag==""||modeFlag=='否'||modeFlag=='N') modeFlag='N';
                else modeFlag='Y';
           		if(!modeCode||!modeDesc||!modeExcCode){
                	alert("统计模式编码、描述或执行代码不能为空！");
                	return;
                }          
           		paraValues='modeCode='+modeCode+'&modeDesc='+modeDesc+'&modeExcCode='+modeExcCode+'&modeFlag='+modeFlag;             
           		dhcwl.complexrpt.Util.ajaxExc(serviceUrl+'?action=addMode&'+paraValues);
           		store.load();
           		grid.show();	
            }
        }, '-',{
        	cls:'align:right',
        	text: '<span style="line-Height:1">更新</span>',
        	icon   : '../images/uiimages/update.png',
            handler: function() {
            	var cursor=Math.ceil((pageTool.cursor + pageTool.pageSize) / pageTool.pageSize);
                var paraValues; //=form.getValues(true);此方法会出现乱码
                var sm = grid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
                	alert("请选择要保存的统计模式");
                	return;
                }
                var modeId=record.get("modeId");
                var modeCode=Ext.get('modeCode').getValue();
                var modeDesc=Ext.get('modeDesc').getValue();
                var modeExcCode=Ext.get('modeExcCode').getValue();
                var modeFlag=modeFlagCombo.getRawValue();
                if(!modeFlag||modeFlag==""||modeFlag=='否'||modeFlag=='N') modeFlag='N';
                else modeFlag='Y';
                var reg=/[\$\#\@\&\%\!\*\^\~||]/;
                var reg2=/^\d/;
                if(reg.test(modeCode)||(reg2.test(modeCode))){
                	alert("统计模式代码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符?并且不能以数字开头");
                	Ext.get("modeCode").focus(); //控制光标的焦点
                	return;
                }
                if(modeCode) modeCode=modeCode.trim(); //截掉常量代码左右空格
                if(!modeCode||!modeDesc||!modeExcCode){
                	alert("统计模式代码或描述或执行代码不能为空!");
                	return;
                }                
                paraValues='modeId='+modeId+'&modeCode='+modeCode+'&modeDesc='+modeDesc+'&modeExcCode='+modeExcCode+'&modeFlag='+modeFlag;
                //record.set("modeCode",modeCode),record.set("modeDesc",modeDesc),record.set("modeExcCode",modeExcCode);
                //record.set("modeFlag",modeFlag);
                dhcwl.complexrpt.Util.ajaxExc(serviceUrl+'?action=updateMode&'+paraValues);
                //store.proxy.setUrl(encodeURI(serviceUrl+'?action=mulSearch'));
                store.load();
                pageTool.cursor=0;
                pageTool.doLoad(pageTool.pageSize*(cursor-1));
                
           }
        },'-',{text: '<span style="line-Height:1">清空</span>',
        	icon   : '../images/uiimages/clearscreen.png',
        	cls:'align:right',
            handler: function() {
            	var form=modeForm.getForm();
    			form.setValues({modeId:'',modeCode:'',modeDesc:'',modeExcCode:'',modeFlagCombo:''});
        	}
        },'-',{text: '<span style="line-Height:1">查询</span>',
        	icon   : '../images/uiimages/search.png',
        	cls:'align:right',
            handler: function() {
            	var modeId=Ext.get('modeId').getValue();
                var modeCode=Ext.get('modeCode').getValue();
                var modeDesc=Ext.get('modeDesc').getValue();
                var modeExcCode=Ext.get('modeExcCode').getValue();
                var modeFlag=modeFlagCombo.getValue();
                paraValues='modeId='+modeId+'&modeCode='+modeCode+'&modeDesc='+modeDesc+'&modeExcCode='+modeExcCode+'&modeFlag='+modeFlag;
                store.proxy.setUrl(encodeURI(serviceUrl+'?action=mulSearch&'+paraValues+'&onePage=1'));
            	store.load();
    			//grid.show();

           }
        }
      ])
	});
            
   var modeShowWin =new Ext.Panel({
    	title:'统计模式维护',
    	layout:'auto',
        items: [{
        	region: 'north',
            //height: 148,
            //autoScroll:true,
            items:modeForm
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
    this.getmodeShowWin=function(){
    	//kpiGrid.setHeight(kpiShowWin.getHeight()-158);
    	return modeShowWin;
    }
    this.getmodeForm=function(){
    	return modeForm;
    }
    this.getmodeGrid=function(){
    	return grid;
    }
    this.getRecord=function(){
    	return record;
    }
}

dhcwl.complexrpt.RptStatMode.prototype.refresh=function(){
	this.getStore().proxy.setUrl(encodeURI("dhcwl/complexrpt/statmodeservice.csp?action=mulSearch&onePage=1"));
	this.getStore().load();
    this.getMcGrid().show();
}