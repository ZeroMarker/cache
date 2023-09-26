function InitViewscreen(){
	var obj = new Object();
	obj.BtnSave = new Ext.Button({
			id : 'winfBtnSave'
			,iconCls : 'icon-save'
			,text : '保存'
			,handler: function(){
							obj.updateForm();	
			}
	  });
	obj.txtFormID = new Ext.form.TextField({
			id : 'txtFormID'
			,readOnly:true
		//	,fieldLabel : '表单ID'
			,anchor : '95%'
			//,value:id	
			,hidden:true			
	});
	obj.txtCName = new Ext.form.TextField({
			id : 'txtCName'
			,fieldLabel : '中文名称'
			,anchor : '95%'
		//	,value:CName
	});
	obj.txtEName = new Ext.form.TextField({
			id : 'txtEName'
			,fieldLabel : '英文名称'
			,anchor : '95%'
			//,value:EName
			,allowBlank:false
	});		
	obj.formBusinessStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.formBusinessStore = new Ext.data.Store({
		proxy: obj.formBusinessStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'myid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'myid', mapping: 'myid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
		])
	});		
	obj.txtBusiness = new Ext.form.ComboBox({
				fieldLabel: '业务类型',
				name: 'txtBusiness',
				//typeAhead: true,
				minChars : 1,
				triggerAction: 'all',
				//mode: 'local',
				store: obj.formBusinessStore,
				valueField: 'Code',
				displayField: 'Description',
				anchor : '95%',
			//	value:BusinessName,
				allowBlank:false
		});
			obj.formBusinessStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.Arg1 = 'CRBusiness';
			param.ArgCnt = 1;
	});
	obj.formBusinessStore.load({});
	
	obj.fPanel = new Ext.form.FormPanel({
				id : 'fPanel'
			//	,title:'表单编辑'
				,buttonAlign : 'right'
				,labelWidth : 70
				,region : 'north'
				,layout : 'form'
				,frame : true
				,height : 250
				,width:300
				,items:[
					obj.txtFormID
					,obj.txtCName
					,obj.txtEName
					,obj.txtBusiness
				]
			});
		/*	
	obj.msForm = new Ext.form.FormPanel({
       // title: '状态字典',
        //width: 700,
       // bodyStyle: 'padding:10px;',
        //renderTo: 'multiselect',
        items:[{
            xtype: 'multiselect',
            fieldLabel:'状态字典',
            name: 'multiselect',
            width: 150,
            height: 100,
            allowBlank:false,
            store: [[123,'One Hundred Twenty Three'],
                    ['1', 'One'], ['2', 'Two'], ['3', 'Three'], ['4', 'Four'], ['5', 'Five'],
                    ['6', 'Six'], ['7', 'Seven'], ['8', 'Eight'], ['9', 'Nine']],
            ddReorder: true
        }]
    });
		*/
   obj.panel = new Ext.Panel(
   {
	   id:'hwq',
	  // renderTo:'div',
	  height:210,
	   title:'状态字典',
	   html: array.join('')
   });

			
	var isSubmitData = new Ext.grid.CheckColumn({
       header: '是否提交数据',
       dataIndex: 'IsSubmitData',
       width: 55
    });
   var isCheckData = new Ext.grid.CheckColumn({
       header: '是否校验数据',
       dataIndex: 'IsCheckData',
       width: 55
       /*,renderer:function(v, p, record){
       	p.css += ' x-grid3-check-col-td';
				if(record.data["isSubmitData"]==1){  
        	        
         return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
        } 
        else{
        	record.set(this.dataIndex, 0);
        	return String.format('<div class="x-grid3-check-col{0}">&#160;</div>', v ? '-on' : '');
        } 
      }*/
    });
	obj.editGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.editGridPanelStore = new Ext.data.Store({
		proxy: obj.editGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'StatusCode'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'FormStaID', mapping : 'FormStaID'}
			,{name: 'StatusCode', mapping: 'StatusCode'}
			,{name: 'StatusName', mapping: 'StatusName'}
			,{name: 'IsSubmitData', mapping: 'IsSubmitData', type : 'int'}
			,{name: 'IsCheckData', mapping: 'IsCheckData', type : 'int'}
		])
	});

	obj.editGridPanel = new Ext.grid.EditorGridPanel({
		id : 'editGridPanel'
		,store : obj.editGridPanelStore
		,title:"表单状态列表"
		,height : 210
		,loadMask : true
		,plugins:[isSubmitData,isCheckData]
		,region : 'center'
		,clicksToEdit: 1
		,viewConfig: {forceFit: true}
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '状态ID', width: 60, dataIndex: 'FormStaID', hidden:true,editable:false}
			,{header: '代码', width: 60, dataIndex: 'StatusCode', sortable: true,editable:false}
			,{header: '名称', width: 60, dataIndex: 'StatusName', sortable: true,editor: {
                xtype: 'textfield',
                allowBlank: false
            }}
			,isSubmitData   
      ,isCheckData
		]
		,tbar:[
			'->',{
			text:"保存"
			,handler: function(){
  					obj.updateFormSta();
  				}
  			}
		]	
	});	

		obj.editGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CR.PO.FormStatus';
			param.QueryName = 'QueryFormStatus';
			param.Arg1 =FormID;  //obj.txtFormID.getValue()只能在为obj.txtFormID赋值之后使用
			param.ArgCnt = 1;
	});		
		obj.editGridPanelStore.load({});
	obj.btn1 = new Ext.Panel({
		id : 'btn1'
		,layout : 'form'
		,height:90
		,buttonAlign : 'center'
		,buttons:[
			{
  				text: '>>',
  				handler: function(){
  					obj.onAdd();
  				}
       }
		]
	});	
		obj.btn2 = new Ext.Panel({
		id : 'btn2'
		,layout : 'form'
		,height:30
		,buttonAlign : 'center'
		,buttons:[
			{
  				text: '<<<',
  				handler: function(){
  					obj.onDelete();	
  				}
       }
		]
	});	
	obj.centerPanel=new Ext.Panel({
		id : 'pnCol11'
	  ,frame:true
		,region : 'center'
		,layout : 'column'
		,items:[
				{
					columnWidth:.2,
					layout: 'form',
					items: [
						obj.panel
					//	obj.msForm
					]
				},
				{
					columnWidth:.3,
					layout: 'form',
					buttonAlign : 'center',
					items: [
						obj.btn1 
						,obj.btn2					
					]
        },
        {
						columnWidth:.5,
						layout: 'form',
						items: [
							obj.editGridPanel
						]
       	 }]
	});
  obj.ViewPort = new Ext.Viewport({
      id:'Viewscreen'
			,layout: 'border'
			,items: [
				obj.fPanel
				//,obj.editGridPanel
				,obj.centerPanel
			 ,{
        region: 'south'
        ,frame:true
        ,buttons:[
				  obj.BtnSave
				  /*,{
  				text: 'wert',
  				handler: function(){
  					alert(obj.txtFormID.getValue());
  				}
       	}*/
				]
				}
			]
		});

	InitViewscreenEvent(obj);
	//事件处理代码
  obj.LoadEvent(arguments);
  return obj;
}