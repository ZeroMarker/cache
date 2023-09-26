(function(){
	Ext.ns("dhcwl.yzcx.YzcxHosCon");
})();
Ext.onReady(function() {
	var ID=null;
    var serviceUrl="dhcwl/yzcx/yzcxhosconservice.csp";
	var outThis=this;
    var choicehosconUserDr="";
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'ID',sortable:true, width: 80, sortable: true,menuDisabled : true},
        {header:'用户ID',dataIndex:'hosconUserDr',sortable:true, width: 80, sortable: true,menuDisabled : true},
        {header:'用户姓名',dataIndex:'hosconUserName', width: 160, sortable: true,menuDisabled : true},
        {header:'院区对应关系',dataIndex:'flag', width: 160, sortable: true,menuDisabled : true}
    ]);
	
	var storeHosconUser = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSearchUser'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'hosconUserDr'},
            	{name: 'hosconUserName'},
            	{name: 'flag'}
       		]
    	})
    });
    storeHosconUser.load()
	
    var hosconUserGrid = new Ext.grid.GridPanel({
    	title:"已配置用户明细",
        stripeRows:true,
        loadMask:true,
        height:450,        
        store: storeHosconUser,
        resizeAble:true,
        //autoHeight:true,
        enableColumnResize :true,
        cm: columnModel,                                     //表格的列模式，渲染表格时必须设置该配置项 
        sm: new Ext.grid.RowSelectionModel({                 //表格的选择模式 rowdblclick（单击）+ rowclick（双击） 
        	singleSelect: true,                              //singleSelect：是否单选模式，默认为false，即可以选择多条数据
            listeners: {
            	rowselect: function(sm, row, rec) {
            		var id=rec.get("hosconUserDr");
            		var form=userForm.getForm();
                	form.loadRecord(rec);
                	form.setValues({hosconUserDr:id});
              	}
            }
        }),
        listeners :{
        	'click':function(ele,event){
        		var sm=hosconUserGrid.getSelectionModel();
        		if(!sm) return;
        		var record = sm.getSelected();
        		if(!record) return;
        		 var ID=record.get("ID"); 
                if(!ID) {
                	ID="";
                	choicehosconUserDr=ID;
                	return;
                }
                var ID=record.get("ID"); 
				storeHosconHosp.proxy.setUrl(encodeURI(serviceUrl+'?action=list-HosconHosp&hosconUserDr='+ID));  //选中用户，显示用户对于的分院配置
				storeHosconHosp.load(); 
    			hosconHospGrid.show();
        	    }
        	    /*
            'contextmenu':function(event){
        		event.preventDefault();
        		quickMenu.showAt(event.getXY());
        	}*/
        }
       });
    
    //
    var userCombo=new Ext.form.ComboBox({
		xtype : 'combo',
		mode : 'remote',
		width : 380,
		editable:true,           //可编辑
		typeAhead : true,        //模糊查询		
		triggerAction : 'all',   // 显示所有下列数据，一定要设置属性triggerAction为all,点击按钮时的动作.默认为query
		loadingText:'Searching...',
		//pageSize:81,                   //在远程模式下,如果此值大于0会在底部显示一个翻页工具条
		pageSize:20,
		minChars:0,                    //最少输入多少个字开始响应
		queryParam:'jiansuo',          //用于后台接收
		queryDelay:800,                //查询延时,远程默认为500,
		emptyText: '请输入用户姓名关键字检索相关用户',
		selectOnFocus: true,    
		name : 'userCombo',
		id:  'userDr',
		displayField : 'userInfo',    //显示文本
		valueField : 'userDr',      //值
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:'dhcwl/yzcx/yzcxhosconservice.csp?action=getUserCombo'}),
			//reader:new Ext.data.ArrayReader({},[{name:'userDr'},{name:'userInfo'}])
				reader: new Ext.data.JsonReader({											//++modify by wz.2016-12-05
				totalProperty: 'totalNum',
				root: 'root',
				fields:[
					{name: 'userDr'},
					{name: 'userInfo'}
				]
			})
		}),
		listeners :{
			'select':function(combox){
				userCombo.setValue(combox.getRawValue());
			}
		}
	});
    
	var userForm = new Ext.FormPanel({
		title:"待选用户",
		frame: true,
        height: 300,
        width:600,
        labelAlign: 'left',
        bodyStyle:'padding:5px',
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        layout: 'table',
        defaultConfig:{width:130},
        layoutConfig: {columns:4},
        items:[{html: '用户：'},userCombo
         ],
         //,{buttons:
         tbar:new Ext.Toolbar([ 
         {text: '<span style="line-Height:1">保存</span>',	
		  icon   : '../images/uiimages/filesave.png',
          id:'usersave_btn',
          handler:function(){
          var form=userForm.getForm();
          var values=form.getValues(false);
           //var hosconUserDr=userCombo.getRawValue();
           var hosconUserDr=userCombo.getValue();
           if(!hosconUserDr){
                	alert("请选择用户！");
                	return;
                }
                
           paraValues='hosconUserDr='+hosconUserDr;
           //alert(paraValues);                
           dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=saveUser&'+paraValues);   //保存用户配置表
           storeHosconUser.reload();  
           hosconUserGrid.show();     
          }
         },'-',{text: '<span style="line-Height:1">删除</span>',
		 icon   : '../images/uiimages/edit_remove.png',
          id:'userdel_btn',
             handler: function(){
            	var sm = hosconUserGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
               		alert("请选择要删除的行！");
               		return;}
                Ext.Msg.confirm('信息', '确定要删除？', function(btn){
                    if (btn == 'yes') {
                        var ID=record.get("ID");
                        //alert(ID);
                        storeHosconUser.remove(record);
                		dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteUser&ID='+ID);
                		storeHosconHosp.proxy.setUrl(encodeURI(serviceUrl+'?action=list-HosconHosp&hosconUserDr='+ID));
           				storeHosconHosp.reload();
                		storeHosconUser.refresh();
                		
                		}
                	});
                }
         }        
         ])
	});
	
	//用户对应的医院,初始化为空
 var columnModelUsr = new Ext.grid.ColumnModel([
 		{header:'ID',dataIndex:'ID',sortable:true, width: 80, sortable: true,menuDisabled : true},
        {header:'医院ID',dataIndex:'hosConHospDr',sortable:true, width: 80, sortable: true,menuDisabled : true},
        {header:'医院编码',dataIndex:'hosConHospCode', width: 160, sortable: true,menuDisabled : true},
        {header:'医院描述',dataIndex:'hosConHospDesc',sortable:true, width: 160, sortable: true,menuDisabled : true}
        
    ]);
	
	var storeHosconHosp = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=list-HosconHosp&hosconUserDr='+ID}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
        		{name: 'hosConHospDr'},
            	{name: 'hosConHospCode'},
            	{name: 'hosConHospDesc'}
            	
       		]
    	})
    });
    storeHosconHosp.load(); 
	//用户与院区关系列表
    var hosconHospGrid = new Ext.grid.GridPanel({
        title:"用户分院明细",
        stripeRows:true,
        loadMask:true,
        height:450,        
        store: storeHosconHosp,
        resizeAble:true,
        //autoHeight:true,
        enableColumnResize :true,
        cm: columnModelUsr,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true
         
        })        
    });
	
	//全部医院
    var selectedHosIds=[];
	var csm1 = new Ext.grid.CheckboxSelectionModel({
		
		listeners:{
			'rowselect':function(sm,row,rec)
			{
				var rd=rec;
				var hospId=rec.get("hospID");
				//alert(hospId);
				addHospId(hospId);
				},
				'rowdeselect':function(sm,row,rec)
				{
					var hospId=rec.get("hospID");
				    var len=selectedHosIds.length;
				    for(var i=0;i<len;i++)
				    {
				    	if(selectedHosIds[i]==hospId)
				    	{
				    		for(var j=i;j<len;j++)
				    		{
				    			selectedHosIds[j]=selectedHosIds[j+1];
				    		}
				    		selectedHosIds.length=len-1;
				    		break;
				    	}
				    }
				}
			}
		});     
    var columnModelSubGrp = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(),
        csm1,
        {header:'医院ID',dataIndex:'hospID',width: 80, sortable: true,menuDisabled : true},
        {header:'医院编码',dataIndex:'hospCode',sortable:true,  width: 160, sortable: true,menuDisabled : true},
        {header:'医院描述',dataIndex:'hospDesc',sortable:true,  width: 160, sortable: true,menuDisabled : true}
    ]);
    //columnModelSubGrp.defaultSortable = true;
    var storehospDetail = new Ext.data.Store({
    	proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=list-AllHosp'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNums',
            root: 'root',
        	fields:[
        		{name: 'hospID'},
            	{name: 'hospCode'},
            	{name: 'hospDesc'}
       		]
    	})
    });  
    storehospDetail.load()
    
    var hospDetailGrid = new Ext.grid.GridPanel({
        title:"所有分院明细",
        id:'hospDetailGrid',
        //stripeRows:true,
        //loadMask:true,
        height:300, 
        width:600,
        //autoHeight:true, 
        //autoWidth:true,
        //bodyStyle:'width:100%',
        //frame:true, 
        //width:300,
        tbar:new Ext.Toolbar([
         {text: '<span style="line-Height:1">保存</span>',
          id:'hospsave_btn',
		  icon   : '../images/uiimages/filesave.png',
          handler:function(){
          var sm = hosconUserGrid.getSelectionModel();
          var record = sm.getSelected();
          if(!sm||!record){
          alert("请选择要配置的用户！");
          return;}  	
          var ID=record.get("ID");
          //alert(hosconUserDr);	
          if(!ID||ID==""){
            		Ext.Msg.show({title:'错误',msg:"请先选择要维护的用户！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            		return;
            	}
            var length=selectedHosIds.length;
            if (length==0)
            {
            	 alert("请选择用户对应的院区！");
            	 return;
            }
            var hospIdStr=""
           for(var i=0;i<length;i++)
           {
           hosId=selectedHosIds[i];
            if (hospIdStr=="")
            {hospIdStr=hosId;}
            else {
            	hospIdStr=hospIdStr+","+hosId;
            }
           }
           selectedHosIds=[];  ///数组初始化
           //alert(hospIdStr);
           paraValues='hosconUserDr='+ID+'&selecthospPara='+hospIdStr;
           //alert(paraValues);
           dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=savehosp&'+paraValues);   //保存用户配置表
           storeHosconHosp.proxy.setUrl(encodeURI(serviceUrl+'?action=list-HosconHosp&hosconUserDr='+ID));
           storeHosconHosp.reload(); 
           storeHosconUser.proxy.setUrl(encodeURI(serviceUrl+'?action=mulSearchUser'));
           storeHosconUser.reload();
           storehospDetail.proxy.setUrl(encodeURI(serviceUrl+'?action=list-AllHosp'));
           storehospDetail.reload();     
          }
          },'-',{text: '<span style="line-Height:1">删除</span>',id:'del_btn',
		  icon   : '../images/uiimages/edit_remove.png',
          handler:function(){
          		var sm = hosconHospGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
               		alert("请选择要删除的行!");
               		return;}
            	var ID=record.get("ID");
         		storeHosconHosp.remove(record);
           		paraValues='hosconUserDr='+ID;
                //alert(paraValues);                
                dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=delhosp&'+paraValues);
                storeHosconUser.proxy.setUrl(encodeURI(serviceUrl+'?action=mulSearchUser'));
           		storeHosconUser.reload();
                var sm = hosconUserGrid.getSelectionModel();
          		var record = sm.getSelected();
           		var useId=record.get("ID");
                storeHosconHosp.proxy.setUrl(encodeURI(serviceUrl+'?action=list-HosconHosp&hosconUserDr='+useId));
           		//storeHosconHosp.refresh(); 
           		
          }
         }    
         
         ]),       
        store: storehospDetail,
        //resizeAble:true,
        //autoHeight:true,
        enableColumnResize :true,
        cm: columnModelSubGrp,
        sm:csm1
        
        

    });

    
	var hospForm = new Ext.FormPanel({
		frame: true,
        height: 300,
        width:600,
        labelAlign: 'left',
        bodyStyle:'padding:5px',
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        layout: 'table',
        defaultConfig:{width:130},
        items:[hospDetailGrid],
         tbar:new Ext.Toolbar([
         {text: '<span style="line-Height:1">保存</span>',	
          id:'hospsave_btn',
		  icon   : '../Image/icons/table_save.png',
          handler:function(){
          var sm = hosconUserGrid.getSelectionModel();
          var record = sm.getSelected();
          if(!sm||!record){
          alert("请选择要配置的用户！");
          return;}  	
          var ID=record.get("ID");
          //alert(hosconUserDr);	
          if(!ID||ID==""){
            		Ext.Msg.show({title:'错误',msg:"请先选择要维护的用户！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            		return;
            	}
            var length=selectedHosIds.length;
            if (length==0)
            {
            	 alert("请选择用户对应的院区！");
            	 return;
            }
            var hospIdStr=""
           for(var i=0;i<length;i++)
           {
           hosId=selectedHosIds[i];
            if (hospIdStr=="")
            {hospIdStr=hosId;}
            else {
            	hospIdStr=hospIdStr+","+hosId;
            }
           }
           selectedHosIds=[];  ///数组初始化
           //alert(hospIdStr);
           paraValues='hosconUserDr='+ID+'&selecthospPara='+hospIdStr;
           //alert(paraValues);
           dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=savehosp&'+paraValues);   //保存用户配置表
           storeHosconHosp.proxy.setUrl(encodeURI(serviceUrl+'?action=list-HosconHosp&hosconUserDr='+ID));
           storeHosconHosp.reload(); 
           storeHosconUser.proxy.setUrl(encodeURI(serviceUrl+'?action=mulSearchUser'));
           storeHosconUser.reload();
           storehospDetail.proxy.setUrl(encodeURI(serviceUrl+'?action=list-AllHosp'));
           storehospDetail.reload();     
          }
          },'-',{text: '<span style="line-Height:1">删除</span>',id:'del_btn',
		  icon   : '../Image/icons/table_delete.png',
          handler:function(){
          		var sm = hosconHospGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
               		alert("请选择要删除的行!");
               		return;}
            	var ID=record.get("ID");
         		storeHosconHosp.remove(record);
           		paraValues='hosconUserDr='+ID;
                //alert(paraValues);                
                dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=delhosp&'+paraValues);
                storeHosconUser.proxy.setUrl(encodeURI(serviceUrl+'?action=mulSearchUser'));
           		storeHosconUser.reload();
                var sm = hosconUserGrid.getSelectionModel();
          		var record = sm.getSelected();
           		var useId=record.get("ID");
                storeHosconHosp.proxy.setUrl(encodeURI(serviceUrl+'?action=list-HosconHosp&hosconUserDr='+useId));
           		storeHosconHosp.refresh(); 
           		
          }
         }    
         
         ])
	
	})
	function ItemPara(){
		var idStr="";    //strPara="",
        //var len=storeSubGrp.getTotalCount();
        var len=hosconHospGrid.getStore().getCount();   //grid行数
        //alert(len);
        var idStr="";
		for(var i=0;i<len;i++){
			hospId=storeHosconHosp.getAt(i).get('ID');
			if(idStr==""){
				idStr=hospId+"*"+(i+1);
				}else{
					idStr=idStr+"-"+hospId+"*"+(i+1)
					}		
				}
		strPara=idStr;
		//alert(strPara);
	
	}
    var hosconPanel =new Ext.Panel ({ //Viewport({
    	title:'院区维护',
    	layout:'table',    //border 
    	layoutConfig: {columns:2},
    	//defaults: { width:300, height: 300},
        items: [{ 
        	autoScroll:true,
            items:userForm
    	},{
            autoScroll:true,
            items:hospDetailGrid //codecfggroupGrid
        },{
            autoScroll:true,
            //width:500,
            //height:500,
            items:hosconUserGrid  
    	},{
            autoScroll:true,
            //width:500,
            //height:500,
            items:hosconHospGrid
        }],
        listeners:{
    		"resize":function(win,width,height){
    			//unchoiceGrid.setHeight(height-150);
    			hosconUserGrid.setHeight(height-150);
    			hosconHospGrid.setHeight(height-150);
				hosconPanel.doLayout();
    			//unchoiceGrid.setWidth(width-choiceGrid1.width-choiceGrid1.width);
    			//unchoiceGrid.setHeight(height-50);
    		}
    	}
    });
    
    this.mainWin=new Ext.Viewport({
    	id:'maintainCodeCfgGroup',
        //renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        resizable:true,
        layout: 'fit',
        //width:1000,
        //heitht:800,
        items: [hosconPanel]
    });
   function addHospId(hospId){
		if((hospId=="")|| (!hospId)) return;
		for(var i=selectedHosIds.length-1;i>-1;i--)
		{
			if(selectedHosIds[i]==hospId) return;
			
			}
			selectedHosIds.push(hospId);
		}; 
	
})
    
   
   

