
//-------------------------------------------------------------度量维护维护界面----------------------------------------------------------
//-------------------------------------------------------------以下是度量grid----------------------------------------------------------
dhcwl.dimrole.AddMeasure=function(store){
	var serviceUrl="dhcwl/measuredimrole/measure.csp";
	var outThis=this;
	var parentWin=null;
    //-------------------------------------------------------以下是度量form---------------------------------------
    var dataSourceCombo=new Ext.form.ComboBox({
		width : 130,
		listWidth:250,
		editable:false,
		allowBlank: false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		//emptyText:'请选择数据源',
		fieldLabel : '数据源',
		name : 'dataSource',
		id : 'dataSource',
		displayField : 'code',
		valueField : 'ID',
		queryParam:'ID',
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=getDataSource'}),
			reader:new Ext.data.ArrayReader({},[{name:'ID'},{name:'code'}])
		}),
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:18px;">' +   
			'{code}' +   
			'</div>'+   
			'</tpl>',	
		listeners :{
			'select':function(combox){
				dataSourceCombo.setValue(combox.getRawValue());
				calItemCombo.setValue("");
				meastaCalCombo.setValue("");
			}
		}
	});
    
    var mstore=new Ext.data.Store({
  	   proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=getCalItem'}),
  		   reader:new Ext.data.ArrayReader({},[{name:'value'},{name:'name'}])
     });
    var calItemCombo=new Ext.form.ComboBox({
		width : 130,
		listWidth:250,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		//emptyText:'请选择计算项',
		fieldLabel : '计算项',
		name : 'calItemCombo2',
		id : 'calItemCombo2',
		displayField : 'name',
		valueField : 'value',
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:18px;">' +   
			'{name}' +   
			'</div>'+   
			'</tpl>',
		store : mstore,
		listeners :{
			'beforequery':function(e){
				ID=Ext.getCmp('dataSource').getValue();
				if (ID==""){
					return
				}
	     		mstore.proxy.setUrl(encodeURI(serviceUrl+'?action=getCalItem&ID='+ID));
	     		mstore.load();
	     		return false;
	     	},
			'select':function(combox){
				calItemCombo.setValue(combox.getRawValue());
			}
		}
	});
    
    var meastastore=new Ext.data.Store({
   	   proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=getMeastaCal'}),
   		   reader:new Ext.data.ArrayReader({},[{name:'value'},{name:'name'}])
      });
    var meastaCalCombo=new Ext.form.ComboBox({
		width : 130,
		listWidth:250,
		editable:false,
		allowBlank: false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		//emptyText:'请选择统计口径',
		fieldLabel : '统计口径',
		name : 'meastaCalCombo2',
		id : 'meastaCalCombo2',
		displayField : 'name',
		valueField : 'value',
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:18px;">' +   
			'{name}' +   
			'</div>'+   
			'</tpl>',
		store : meastastore,
		listeners :{
			'beforequery':function(e){
				ID=Ext.getCmp('dataSource').getValue();
				if (ID==""){
					return
				}
				meastastore.proxy.setUrl(encodeURI(serviceUrl+'?action=getMeastaCal&ID='+ID));
				meastastore.load();
	     		return false;
	     	},
			'select':function(combox){
				meastaCalCombo.setValue(combox.getRawValue());
			}
		}
	});
    
	//度量Form
	var meaForm = new Ext.FormPanel({
		bodyStyle:'padding:5px',
        style: {
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        labelAlign: 'right',
        buttonAlign:'center',
		frame : true,
		bodyStyle:'padding:5px',
		labelWidth : 60,
		items:[{
			layout:'column',
			items:[{
				columnWidth:.35,
				layout:'form',
				defaultType:'textfield',
				defaults:{
					width:270
				},
				items:[dataSourceCombo,{
					fieldLabel:'编码',
					name      :'measureCode1',
					id        :'measureCode1',
					allowBlank: false
				},{
					fieldLabel :'创建时间',
					xtype	   :'datefield',
					name	   :'measureDate1',
					id	       :'measureDate1',
					//format     :'GetWebsysDateFormat(),
					value      :new Date(),
					disabled   :true
				}]
			},{
				columnWidth:.30,
				layout:'form',
				defaultType:'textfield',
				defaults:{
					width:240
				},
				items:[meastaCalCombo,{
					fieldLabel :'描述',
					name	   :'measureDesc1',
					id	       :'measureDesc1',
					allowBlank : false
				}]
			},{
				columnWidth:.30,
				layout:'form',
				defaultType:'textfield',
				defaults:{
					width:240
				},
				items:[calItemCombo,{
					fieldLabel :'创建人',
					name	   :'measureCreator1',
					id	       :'measureCreator1'
				}]
			}]
		}],
		buttons:new Ext.Toolbar([
        {
        	//text:'保存',
			text: '<span style="line-Height:1">保存</span>',
        	icon: '../images/uiimages/filesave.png',
            handler:function(){
            	var code=Ext.get('measureCode1').getValue();
            	//var dataSource=Ext.get('dataSource').getCmpValue();
				var dataSource=Ext.getCmp('dataSource').getValue();
            	var calItem=Ext.get('calItemCombo2').getValue();
            	var meastaCal=Ext.get('meastaCalCombo2').getValue();
            	var desc=Ext.get('measureDesc1').getValue();
            	var creator=Ext.get('measureCreator1').getValue();
            	//alert(code+" "+dataSource+" "+calItem+" "+meastaCal+" "+desc+" "+creator);
            	//return;
				if ((dataSource=="")||(meastaCal=="")||(code=="")||(desc=="")){
                	Ext.Msg.alert("提示","请将信息填写完整后再进行保存操作");
                	return;
                }
            	var reg=/[\$\#\@\&\%\!\*\^\~||\-\(\)\']/;
                var reg2=/^\d/;
                var reg3=/\s/;
                if(reg.test(code)||(reg2.test(code))||(reg3.test(code))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||,-,(,),'以及空格等特殊字符，并且不能以数字开头");
                	return;
                }
				//calItem=chagEncodeURL(calItem);
                var paraValues='code='+code+'&dataSource='+dataSource+'&calItem='+calItem+'&meastaCal='+meastaCal+'&desc='+desc+'&creator='+creator
                dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=addMeasure&'+paraValues
		                ,null,function(jsonData){
		                	if(!jsonData){
		                		Ext.Msg.show({title:'错误',msg:"增加失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		                		return;
		                	}
		                	if(jsonData.success){
		                		if (jsonData.tip=="ok") {
		                			Ext.Msg.show({title:'提示',msg:"增加成功！",buttons: Ext.Msg.OK});
									parentWin.refresh();
		                			
		                	}else{
									Ext.Msg.alert("提示",jsonData.tip);
		                		}
		                	}else{
		                		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		                		return;
		                	}
		                },outThis);
            	addMainWin.close();
        		addMainWin.destroy();
            }
        },"-",{
        	//text:'退出',
			text: '<span style="line-Height:1">关闭</span>',
        	icon: '../images/uiimages/undo.png',
        	handler: function() {
        		addMainWin.close();
        		addMainWin.destroy();
        	}
        }])
	});
	
	//------------------------------------------------以下是整体界面的布局管理-----------------------------------------
    
	var addMeaPanel =new Ext.Panel ({ 
    	//title:'度量维护',
    	//border:false,
		layout: {
			type: 'vbox',
			pack: 'start',
			align: 'stretch'
		},
		
    	defaults: { border :false},
        items: [{ 
			border :false,
			flex:1,
			layout:"fit",
            items:[
			{
				layout: {
					type: 'hbox',
					pack: 'start',
					align: 'stretch'
				},				
				items:[{
					flex:1,
					layout:"fit",
					items:meaForm
				}]
			}]
    	}]
    });
    
	this.setCalF=function(exec){
		calItemCombo.setValue(exec);	
	}
    this.setParentWin=function(parent){
		parentWin=parent;
    }
	function OnShowExpVal(){
		var calDef=new dhcwl.schema.CalDef(outThis);
		
		calDef.show();					
	}
    
    var addMainWin=new Ext.Window({
    	id:'maintainAddMeaWin',
		title:'度量维护',
    	//border:false,
    	width:1100,
    	height:260,
        layout: 'fit',
        items: [meaForm],
        listeners:{
			'close':function(){
				addMainWin.destroy();
			}
    	}
    });
    
    this.showWin=function(){
    	addMainWin.show();
    }
    
    
}
