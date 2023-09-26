(function(){
	Ext.ns("dhcwl.complexrpt.RptDefine");
})();

dhcwl.complexrpt.RptDefine=function(){
	  var serviceUrl="dhcwl/complexrpt/rptdefservice.csp";
      var quickMenu=new Ext.menu.Menu({
		//autoWidth:true,
		boxMinWidth:150,
		ignoreParentClicks:true,
    	items:[
    		{
    			text:'维护报表配置',
    			handler:function(cmp,event){
		    				var sm = grid.getSelectionModel();
		                	if(!sm){
		                		alert("请选择一行！");
		                		return;
		                	}
		                    var record = sm.getSelected();
		                    if(!record){
		                		alert("请选择一行！");
		                		return;
		                	}
		                	var mRptCode=record.get('rptCode');
		                	var mRptName=record.get('rptName');
							var rptWinCfg=new dhcwl.complexrpt.TestRow(mRptCode,mRptName);
							rptWinCfg.showRptCfgWin().show();

    			}
    		},{
				text:'修改关联指标',
				handler:function(){
					var sm = grid.getSelectionModel();
                	if(!sm){
                		alert("请选择一行！");
                		return;
                	}
                    var record = sm.getSelected();
                    if(!record){
                		alert("请选择一行！");
                		return;
                	}
					var linkRptCode=record.get('rptCode');
					var linkRptId=record.get('rptId');
					var rptLinkKpi = new dhcwl.complexrpt.RptLinkKpi(linkRptCode,linkRptId);
					rptLinkKpi.showRptlinkKpi().show();
				}
			},{
    			text:'生成报表数据',
    			handler:function(){
    				var sm = grid.getSelectionModel();
                	if(!sm){
                		alert("请选择一行！");
                		return;
                	}
                    var record = sm.getSelected();
                    if(!record){
                		alert("请选择一行！");
                		return;
                	}
                	var dataRptCode=record.get('rptCode');
					var dataRptId=record.get('rptId');
                	dhcwl_mkpi_createRptData=new dhcwl.complexrpt.CreateRptData(dataRptCode);
                	dhcwl_mkpi_createRptData.show();
    			}
    		},{
    			text:'预览报表数据',
    			handler:function(){
			    	var sm = grid.getSelectionModel();
                	if(!sm){
                		alert("请选择一行！");
                		return;
                	}
                    var record = sm.getSelected();
                    if(!record){
                		alert("请选择一行！");
                		return;
                	}
                	var viewRptCode=record.get('rptCode');
					var viewRptId=record.get('rptId');
    				dhcwl_mkpi_previewKpiData=new dhcwl.complexrpt.ViewRptData(viewRptCode);
    				dhcwl_mkpi_previewKpiData.showWin();
    			}
    		}
    	]
     });
     
      var outThis=this;
	  var kpiObj=null;
	  var selectedRptIds=[];
      var selectedRptCodes=[];
      //复选框
      var csm=new Ext.grid.CheckboxSelectionModel({
	      listeners :{
		      rowselect: function(sm, row, rec) {
			      var rd=rec;   //sm.getSelected();
			      var rptId=rec.get("rptId");
			      rptForm.getForm().loadRecord(rec);
			      //rptSortCombo.setRawValue(rd.get('rptFL'));
			      var rptCode=rec.get("rptCode");
			      addSelectedRptId(rptId,rptCode);
			  },
            'rowdeselect':function(sm, row, rec){
				var rptId=rec.get("rptId"),len=selectedRptIds.length;
				for(var i=0;i<len;i++){
					if(selectedRptIds[i]==rptId){
						for(var j=i;j<len;j++){
							selectedRptIds[j]=selectedRptIds[j+1]
						}
						selectedRptIds.length=len-1;
						break;
					}
				}
			}
		}
      });
            
            //定义列
	var columnModel = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
        {header:'ID',dataIndex:'rptId',sortable:true, width: 30, sortable: true ,menuDisabled : true
        },{header:'报表代码',dataIndex:'rptCode', width: 100, sortable: true ,menuDisabled : true 
        },{header:'报表名称',dataIndex:'rptName', width: 200, sortable: true ,menuDisabled : true 
        },{header:'报表描述',dataIndex:'rptDesc', width: 300, sortable: true ,menuDisabled : true
        },{header:'报表分类',dataIndex:'rptFL', width: 100, sortable: true ,menuDisabled : true
        },{header:'更新时间',dataIndex:'rptUpdateDate', width: 100, sortable: true ,menuDisabled : true
        },{header:'备注',dataIndex:'rptRemark', width: 100, sortable: true ,menuDisabled : true
        }
    ]);
           //定义报表的存储模型
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSearch'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'rptId'},
            	{name: 'rptCode'},
            	{name: 'rptName'},
            	{name: 'rptDesc'},
            	{name: 'rptFL'},
            	{name: 'rptUpdateDate'},
            	{name: 'rptRemark'}
       		]
    	})
    });
    //start
    var record= Ext.data.Record.create([
        {name: 'rptId', type: 'int'},
        {name: 'rptCode', type: 'string'},
        {name: 'rptName', type: 'string'},
        {name: 'rptDesc',type: 'string'},
        {name: 'rptFL',type: 'string'},
        {name: 'rptUpdateDate',type: 'string'},
        {name: 'rptRemark',type: 'string'}
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
				var id="",j=0,found=false,storeLen=selectedRptIds.length;
				for(var i=store.getCount()-1;i>-1;i--){
					id=store.getAt(i).get("rptId");
					found=false;
					for(j=storeLen-1;j>-1;j--){
						if(selectedRptIds[j]==id) found=true;
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
		id:"rptTables",
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
   				quickMenu.showAt(event.getXY());
   				var sm = this.getSelectionModel();
  				var record = sm.getSelected();
 				if(record){
 					var record = sm.getSelected();
 				}
    		}
		}
     });
     
     var rptSortCombo=new Ext.form.ComboBox({
		width : 120,
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all', //显示所有下拉数据
		value:'ComplexQuery', //默认值
		name : 'rptSortCombo',
		displayField : 'rptSort',
		valueField : 'rptSortV',
		store : new Ext.data.JsonStore({
			fields : ['rptSort', 'rptSortV'],
			data : [{
				rptSort : '收入综合查询',
				rptSortV : 'ComplexQuery'
			}, {
				rptSort : '收入明细查询',
				rptSortV : 'DetailQuery'
			}]})
	});
     
      //表单
	var rptForm=new Ext.FormPanel({
        //id: 'kpi-list',
    	height: 130,
        frame: true,
        autoScroll:true,
        labelAlign: 'right',
        bodyStyle:'padding:5px',
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        //defaultConfig:{width:110},
        items : [{
					layout : 'column',
					items : [{
						labelWidth : 60,
						columnWidth : .18,
						layout : 'form',
						defaultType : 'textfield',
						defaults : {
							width : 120
						},
						items : [{
									fieldLabel : 'ID',
									id : 'rptId',
									name : 'rptId',
									disabled : true
								}, {
									fieldLabel : '报表分类',
									id : 'rptFL',
									name : 'rptFL'
								}]
					}, {
						labelWidth : 60,
						columnWidth : .22,
						layout : 'form',
						// defaultType : 'textfield',
						defaults : {
							width : 160
						},
						items : [{
									fieldLabel : '报表代码',
									xtype : 'textfield',
									id : 'rptCode',
									name : 'rptCode'
								}, {
									fieldLabel : '备注',
									xtype : 'textfield',
									id : 'rptRemark',
									name : 'rptRemark'
								}]
					}, {
						labelWidth : 60,
						columnWidth : .25,
						layout : 'form',
						defaults : {
							width : 200
						},
						items : [{
									xtype : 'textfield',
									fieldLabel : '报表名称',
									id : 'rptName',
									name : 'rptName'
								}, {
									fieldLabel : '报表描述',
									xtype : 'textfield',
									id : 'rptDesc',
									name : 'rptDesc'
								}]
					}]

				}],
         tbar: new Ext.Toolbar([{
			 text: '<span style="line-Height:1">增加报表</span>',
            icon   : '../images/uiimages/edit_add.png',
            handler: function(){
            	var cursor=Math.ceil((pageTool.cursor + pageTool.pageSize) / pageTool.pageSize);
				var form=rptForm.getForm();
          		var values=form.getValues(false);
          		var rptCode=Ext.get('rptCode').getValue();
          		var reg=/[\$\#\@\&\%\!\*\^\~||]/;
                var reg2=/^\d/;
                if(reg.test(rptCode)||(reg2.test(rptCode))){
                	alert("报表编码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符，并且不能以数字开头！");
                	Ext.get("rptCode").focus();
                	return;
                }
           		var rptCode=Ext.get('rptCode').getValue();
           		var rptName=Ext.get('rptName').getValue();
           		var rptDesc=Ext.get('rptDesc').getValue();
           		var rptFL=Ext.get('rptFL').getValue();
           		//var rptFL=rptSortCombo.getValue();
           		var rptRemark=Ext.get('rptRemark').getValue();
           		if(!rptCode||!rptName){
                	alert("报表编码与名称不能为空！");
                	return;
                }          
           		paraValues='rptCode='+rptCode+'&rptName='+rptName+'&rptDesc='+rptDesc+'&rptFL='+rptFL+'&rptRemark='+rptRemark;             
           		//dhcwl.complexrpt.Util.ajaxExc(serviceUrl+'?action=addRpt&'+paraValues);
           		var url=serviceUrl+'?action=addRpt&'+paraValues
           		dhcwl.complexrpt.Util.ajaxExc(url,null,function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					//refresh();
					//csm.selectLastRow()
					Ext.Msg.confirm('信息', '是否现在配置报表？', function(btn){
                    	if (btn == 'yes') {
                    		store.load();
           					grid.show();
	    					var rptWinCfg=new dhcwl.complexrpt.TestRow(rptCode,rptName);
							rptWinCfg.showRptCfgWin().show();
                    	}else{
                    		store.load();
                    		pageTool.cursor=0;
                			pageTool.doLoad(pageTool.pageSize*(cursor-1));
           					//grid.show();
                    	}
					});
				}else{
					Ext.Msg.alert("提示",jsonData.tip);
					}
				},this);
            }
        }, '-',{
        	cls:'align:right',
			text: '<span style="line-Height:1">更新报表</span>',
        	icon   : '../images/uiimages/update.png',
            handler: function() {
            	var cursor=Math.ceil((pageTool.cursor + pageTool.pageSize) / pageTool.pageSize);
                var paraValues; //=form.getValues(true);此方法会出现乱码
                var sm = grid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
                	alert("请选择要保存的报表");
                	return;
                }
                var rptId=Ext.get("rptId").getValue();
                var rptCode=Ext.get('rptCode').getValue();
           		var rptName=Ext.get('rptName').getValue();
           		var rptDesc=Ext.get('rptDesc').getValue();
           		var rptFL=Ext.get('rptFL').getValue();
           		//var rptFL=rptSortCombo.getValue();
           		var rptRemark=Ext.get('rptRemark').getValue();
                var reg=/[\$\#\@\&\%\!\*\^\~||]/;
                var reg2=/^\d/;
                if(reg.test(rptCode)||(reg2.test(rptCode))){
                	alert("报表代码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符?并且不能以数字开头");
                	Ext.get("rptCode").focus(); //控制光标的焦点
                	return;
                }
                if(rptCode) rptCode=rptCode.trim(); //截掉常量代码左右空格
                if(!rptCode||!rptName){
                	alert("报表代码或名称不能为空!");
                	return;
                }                
                paraValues='rptId='+rptId+'&rptCode='+rptCode+'&rptName='+rptName+'&rptDesc='+rptDesc+'&rptFL='+rptFL+'&rptRemark='+rptRemark;
                //record.set("modeCode",modeCode),record.set("modeDesc",modeDesc),record.set("modeExcCode",modeExcCode);
                //record.set("modeFlag",modeFlag);
                dhcwl.complexrpt.Util.ajaxExc(serviceUrl+'?action=updateRpt&'+paraValues);
                //store.proxy.setUrl(encodeURI(serviceUrl+'?action=mulSearch'));
                store.load();
                pageTool.cursor=0;
                pageTool.doLoad(pageTool.pageSize*(cursor-1));
                
           }
        },'-', {
			text: '<span style="line-Height:1">删除报表</span>',
            icon   : '../images/uiimages/edit_remove.png',
            handler: function(){            
                var sm = grid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
                	alert("请选择要删除的报表！");
                	return;
                }
                var rptId=Ext.get("rptId").getValue();
                if(rptId) rptId=rptId.trim(); //截掉常量代码左右空格
                var cursor=Math.ceil((pageTool.cursor + pageTool.pageSize) / pageTool.pageSize);
				var url=serviceUrl+'?action=deleteRpt&rptId='+rptId
                Ext.Msg.confirm('信息', '删除报表时，会删除报表及其所有的配置，确定要删除？', function(btn){
                    if (btn == 'yes') {
						dhcwl.complexrpt.Util.ajaxExc(url,null,function(jsonData){
							if(jsonData.success==true && jsonData.tip=="ok"){
			     				store.load();
           						grid.show();
			            		pageTool.cursor=0;
                				pageTool.doLoad(pageTool.pageSize*(cursor-1));
                				Ext.Msg.alert("提示","报表删除成功！");
                				var form=rptForm.getForm();
			 					form.setValues({rptId:'',rptCode:'',rptName:'',rptDesc:'',rptFL:'',rptRemark:''});
							}else{
								Ext.Msg.alert("提示",jsonData.tip);
							}		
						},this);
                    }
                });	
              	  
            }
        },'-',{text: '<span style="line-Height:1">清空</span>',		
        	icon   : '../images/uiimages/clearscreen.png',
        	cls:'align:right',
            handler: function() {
            	var form=rptForm.getForm();
    			form.setValues({rptId:'',rptCode:'',rptName:'',rptDesc:'',rptFL:'',rptRemark:''});
        	}
        },'-',{text: '<span style="line-Height:1">查询</span>',
        	icon   : '../images/uiimages/search.png',
        	cls:'align:right',
            handler: function() {
            	var rptId=Ext.get('rptId').getValue();
                var rptCode=Ext.get('rptCode').getValue();
                var rptName=Ext.get('rptName').getValue();
                var rptDesc=Ext.get('rptDesc').getValue();
                var rptFL=Ext.get('rptFL').getValue();
                //var rptFL=rptSortCombo.getValue();
                var rptRemark=Ext.get('rptRemark').getValue();
                paraValues='rptCode='+rptCode+'&rptName='+rptName+'&rptDesc='+rptDesc+'&rptFL='+rptFL+'&rptRemark='+rptRemark;
                store.proxy.setUrl(encodeURI(serviceUrl+'?action=mulSearch&'+paraValues+'&onePage=1'));
            	store.load({params:{start:0,limit:20,onePage:1}});
    			//grid.show();

           }
        },'-',{
		text: '<span style="line-Height:1">配置报表</span>',
        	cls:'align:right',
        	icon   : '../images/uiimages/config.png',
            handler: function() {
				var sm = grid.getSelectionModel();
		      		if(!sm){
		     			alert("请选择一行！");
		                return;
		         	}
		  		var record = sm.getSelected();
		       		if(!record){
		       			alert("请选择一行！");
		           		return;
		      		}
		     	var mRptCode=record.get('rptCode');
		  		var mRptName=record.get('rptName');
				var rptWinCfg=new dhcwl.complexrpt.TestRow(mRptCode,mRptName);
				rptWinCfg.showRptCfgWin().show();
           }
        }
      ])
	});
            
   var rptDefShowWin =new Ext.Panel({
    	title:'报表定义',
    	layout:'auto',
        items: [{
        	region: 'north',
            //height: 148,
            //autoScroll:true,
            items:rptForm
        },{
        	region:'center',
        	//autoScroll:true,
            items:grid
    	}]
    });
    
    store.load({params:{start:0,limit:20,onePage:1}});
    
    this.clearForm=function(){
		var form=rptForm.getForm();
    	form.setValues({rptId:'',rptCode:'',rptName:'',rptDesc:'',rptFL:'',rptRemark:''});
    	return;
    }

	this.getStore=function(){
    	return store;
    }
    this.getColumnModel=function(){
    	return columnModel;
    }
    this.getRptDefShowWin=function(){
    	//kpiGrid.setHeight(kpiShowWin.getHeight()-158);
    	return rptDefShowWin;
    }
    this.getrptForm=function(){
    	return rptForm;
    }
    this.getrptGrid=function(){
    	return grid;
    }
    this.getRecord=function(){
    	return record;
    }
    
  //////将报表id传入报表配置界面，配置该报表的条件
    this.setRptConRowCfg=function(){
		var sm = grid.getSelectionModel();
	    var record = sm.getSelected();
	    if(!sm||!record){
	    	alert("请选择要配置的报表！");
	    	return;
	    }
	    var id=record.get("rptId"),rptName=record.get("rptName");
	    if(!id||id==""){
	    	alert("报表未定义，请定义报表并保存后再执行该操作！")
	    	return;
	    }
	    getRptConRowCfgObj().show(id,rptName);
    
	}
    
    function addSelectedRptId(id,code){
    	if(!id||id=="") return;
		for(var i=selectedRptIds.length-1;i>-1;i--){
			if(selectedRptIds[i]==id)
				return;
		}
		selectedRptIds.push(id);
		selectedRptCodes.push(code);
    }
    
    
    function getRptConRowCfgObj(){
		if(null==dhcwl_complexrpt_mantainRptConRowCfg){
    		dhcwl_complexrpt_mantainRptConRowCfg=new dhcwl.complexrpt.RpConRowCfg("","");
    	}
    	return dhcwl_complexrpt_mantainRptConRowCfg;
	}

}