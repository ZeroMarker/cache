/// 名称: 用法用量
/// 描述: 包含用法用量的保存功能
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2014-12-3
/**----------------------------------调用selector控件JS--------------------------------------**/	
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/MultiSelect.js"> </script>');
document.write('<link rel="stylesheet" type="text/css" href="../scripts/bdp/Framework/css/multiselect.css"> </link>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
Ext.onReady(function() {
	
	Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';

	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var BindingDisease = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseList&pClassQuery=GetDataForCmb1";
	var BindingInstruc = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtInstruc&pClassQuery=GetDataForCmb1";
	var BindingUom = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtUom&pClassQuery=GetDataForCmb1";
	var BindingAge = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassQuery=GetDataForCmb1";
	var BindingAgeUom= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassQuery=GetDataForCmbYMD";
	var BindingICD = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCExtIcdFeild&pClassQuery=GetDataForCmb1";  
	var BindingGen="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGeneric&pClassQuery=GetDataForCmb1";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHUsageDosage&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHUsageDosage";
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHUsageDosage&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHUsageDosage&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHUsageDosage&pClassMethod=DeleteData";
	var QUERY_UnSelDisea_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseList&pClassQuery=GetUnSelDiseaList";
	var ACTION_URL_Disea = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDisease&pClassQuery=GetDiseaList";
	var DELETE_Disea_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDisease&pClassMethod=DeleteDiseaData";
	var AGE_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassMethod=getMaxMin";
	var QUERY_UnSelPopu_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCSpecialPopu&pClassQuery=GetUnSelPopuList";
	var ACTION_URL_Popu = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCLibSpecPopuItm&pClassQuery=GetPopuList";
	var DELETE_Popu_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCLibSpecPopuItm&pClassMethod=DeletePopuData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var pageSize_Disea = Ext.BDP.FunLib.PageSize.Pop;
	var pageSize_Popu = Ext.BDP.FunLib.PageSize.Pop;
	
	var diseaStr="";//2016-08-09
	var PopuStr="";
	
	//---rowid
	var PHUSDORowId = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : 'PHUSDORowId',
		hideLabel : 'True',
		hidden : true,
		id : 'PHUSDORowId',
		name : 'PHUSDORowId'
	});
	//---InstDr
	var PHUSDOInstDr = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : 'PHUSDOInstDr',
		hideLabel : 'True',
		hidden : true,
		id : 'PHUSDOInstDr',
		name : 'PHUSDOInstDr'
	});
	/**********************用法用量主索引开始************************/
	//全局变量
	var GenDr=Ext.BDP.FunLib.getParam("GlPGenDr");
	var Pointer=Ext.BDP.FunLib.getParam("GlPPointer");
	var PointerType = Ext.BDP.FunLib.getParam("GlPPointerType"); 
	/*var text = new Array();
	function getStr(text){
		if(text.length<0) return "";
		var str="";
		for (var i = 0 ; i < text.length; i++){
			if(text[i]==undefined){
				text[i]="";
			}
			str=str+text[i];
		}
		return str;
	}*/
	var PHINSTTypeDr = new Ext.BDP.FunLib.Component.TextField({
		hidden : true,
		id:'TypeDr',
		name : 'PHINSTTypeDr',
		value:'USAGE'
	});
	var PHINSTOrderNum = new Ext.BDP.FunLib.Component.TextField({
		hidden : true,
		id:'OrderNum',
		name : 'PHINSTOrderNum',
		value:0
	});
	var PHINSTGenDr = new Ext.BDP.FunLib.Component.TextField({
		hidden : true,
		id:'GenDr',
		name : 'PHINSTGenDr',
		value:GenDr
	});
	var PHINSTPointerDr = new Ext.BDP.FunLib.Component.TextField({
		hidden : true,
		id:'PointerDr',
		name : 'PHINSTPointerDr',
		value:Pointer
	});
	var PHINSTPointerType = new Ext.BDP.FunLib.Component.TextField({
		hidden : true,
		id:'PointerType',
		name : 'PHINSTPointerType',
		value:PointerType
	});
	var PHINSTLibDr = new Ext.BDP.FunLib.Component.TextField({
		hidden : true,
		id:'LibDr',
		name : 'PHINSTLibDr',
		value:'DRUG'
	});
	var PHINSTActiveFlag = new Ext.BDP.FunLib.Component.TextField({
		hidden : true,
		id:'ActiveFlag',
		name : 'PHINSTActiveFlag',
		value:'Y'
	});
	var PHINSTSysFlag = new Ext.BDP.FunLib.Component.TextField({
		hidden : true,
		id:'SysFlag',
		name : 'PHINSTSysFlag',
		value:'Y'
	});
	/**********************用法用量主索引结束************************/
	//---级别
	var mode = tkMakeServerCall("web.DHCBL.KB.DHCPHInstLabel","GetManageMode","Usage");
	var PHINSTMode = new Ext.BDP.FunLib.Component.BaseComboBox({
		fieldLabel : '<font color=red>*</font>级别',
		name : 'PHINSTMode',
		hiddenName : 'PHINSTMode',
		id:'Mode',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('Mode'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Mode')),
		editable:false,
		allowBlank : false,
		width : 230,
		labelWidth:30,
		mode : 'local',
		triggerAction : 'all',// query
		value:mode,
		valueField : 'value',
		displayField : 'name',
		store:new Ext.data.SimpleStore({
			fields:['value','name'],
			data:[
				      ['W','警示'],
				      ['C','管控'],
				      ['S','统计']
			     ]
		})
	});
	/** ---------病症未选列表内容部分------------* */
	var dsUnSelDisea = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:QUERY_UnSelDisea_URL}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[{ name: 'PHDISLRowId', mapping:'PHDISLRowId',type: 'string'},
	  	{ name: 'PHDISLDiseaCode', mapping:'PHDISLDiseaCode',type: 'string'},
        { name: 'PHDISLDiseaDesc', mapping:'PHDISLDiseaDesc',type: 'string'}
		]),
		remoteSort: true
    });	
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsUnSelDisea
	});
	dsUnSelDisea.on('beforeload',function(thiz,options){ 
		if(typeof(gridWest)!="undefined"){
	    	if(gridWest.getSelectionModel().getCount()!=0){
	    		var	InstId = gridWest.getSelectionModel().getSelections()[0].get('PHUSDOInstDr');
	    	}
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     InstId:InstId,
		     diseaStr:diseaStr //2016-08-09
		  }   
		)
	});
	dsUnSelDisea.load({
		params : {
			start : 0,
			limit : pageSize_Disea
		},
		callback : function(records, options, success) {
		}
	});
	var UnSelDiseaSearch = new Ext.Button({
		id : 'UnSelDiseaSearch',
		iconCls : 'icon-search',
		handler : function() {                                 
			gridUnSelDisea.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelDiseaText").getValue(),
       			diseaStr:diseaStr //2016-08-09
       		};
			gridUnSelDisea.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_Disea
					}
			});
		}
	});	
	var UnSelDiseaRefresh = new Ext.Button({
		id : 'UnSelDiseaRefresh',
		iconCls : 'icon-refresh',
		handler : function() {
			Ext.getCmp("UnSelDiseaText").reset();                    
			gridUnSelDisea.getStore().baseParams={diseaStr:diseaStr};//2016-08-09
			gridUnSelDisea.getStore().load({                           
				params : {
					start : 0,
					limit : pageSize_Disea
				}
			});
		}
	});	
	var UnSelDiseaText = new Ext.BDP.FunLib.Component.TextField({
		id : 'UnSelDiseaText',
		enableKeyEvents : true,
		width:150,
		listeners : {
       	'keyup' : function(field, e){
       		gridUnSelDisea.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelDiseaText").getValue(),
       			diseaStr:diseaStr //2016-08-09
       		};
			gridUnSelDisea.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_Disea
					}
				});
	        }
		}						
	})
	var UnSelDiseaSave = new Ext.Button({			
				xtype : 'button',
				text : '',
				icon : Ext.BDP.FunLib.Path.URL_Icon+'save.gif',
				id:'UnSelDiseaSave',
				handler : function SaveData() {
					var rs=gridUnSelDisea.getSelectionModel().getSelections();
					if(rs.length==0){
						Ext.Msg.show({
							title : '提示',
							msg : '请选择需要保存的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
					}else{
						var fieldStr = "";
						Ext.each(rs,function(){								
							var _record = new Ext.data.Record({
								'PHDDRowId':'',
								'PHDDDiseaDr':this.get('PHDISLRowId'),
						 		'PHDISLDiseaCode':this.get('PHDISLDiseaCode'),
						 		'PHDISLDiseaDesc':gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaDesc')
						 	});
						 	gridDisea.stopEditing();
						 	dsDisea.insert(0,_record); 
						 	
						 	if (diseaStr!=""){
						 		diseaStr=diseaStr+"^<"+gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaCode')+">";
						 	}else{
						 		diseaStr="<"+gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaCode')+">";
						 	}  //2016-08-09
						 	//未选列表删除
						 	//var myrecord=gridUnSelDisea.getSelectionModel().getSelected();
						 	dsUnSelDisea.remove(this);
						 	//页面病症框显示值
						 	var diseaDescs="";
						    dsDisea.each(function(record){
						    	if(diseaDescs==""){
						    		diseaDescs = record.get('PHDISLDiseaDesc');
						    	}else{
						    		diseaDescs = diseaDescs+","+record.get('PHDISLDiseaDesc');
						    	}
						    }, this);
						    Ext.getCmp("Disea").setValue(diseaDescs);
						    if(diseaDescs!=""){
						   		 text[0]="适应证:"+diseaDescs+";";
						    }else{
						    	text[0]="";
						    }
							//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
							
						})				
					}
				},
				scope : this
			});
	var unSelDiseatb = new Ext.Toolbar({
		id : 'unSelDiseatb',
		items : [UnSelDiseaSearch, UnSelDiseaText,UnSelDiseaRefresh,'->',UnSelDiseaSave]
	});
	var pagingUnSelDisea= new Ext.PagingToolbar({
            pageSize: pageSize_Disea,
            store: dsUnSelDisea,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pageSize_Disea=this.pageSize;
				         }
		        }
        })	
	var smUnSelDisea = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridUnSelDisea = new Ext.grid.GridPanel({
		id:'gridUnSelDisea',
		closable:true,
	    store: dsUnSelDisea,
	    trackMouseOver: true,
	    columns: [
	            smUnSelDisea,
	            { header: 'PHDISLRowId', width: 200, sortable: true, dataIndex: 'PHDISLRowId',hidden:true }, 
	            { header: '病症代码', width: 200, sortable: true, dataIndex: 'PHDISLDiseaCode',hidden:true },
	            { header: '病症描述', width: 200, sortable: true, dataIndex: 'PHDISLDiseaDesc' }
	            ],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		tbar : unSelDiseatb, 
		bbar:pagingUnSelDisea,
	    stateId: 'gridUnSelDisea'
	});
	var WinDisea=new Ext.Window({  
        id:'WinDisea',  
        width:240,  
        height:360,        
        autoHeight:false,  
        closeAction:"hide",  
        layout: 'fit',  
        plain: true,  
        title:'病症',  
        items:gridUnSelDisea  
    }); 
	//---病症
	var PHDISLDisea = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '病症',
		name : 'PHDISLDisea',
		id : 'Disea',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('Disea'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Disea')),
		dataIndex:'PHDISLDisea'
	});
	var BtnDisea = new Ext.Button({
		id : 'btnDisea',  
        text : '...',  
        tooltip : '病症未选列表',
        listeners : {  
	        'click' : function() {  
	        	/**病症未选列表加载*/
	        	var InstId="";
			    if(typeof(gridWest)!="undefined"){
			    	if(gridWest.getSelectionModel().getCount()!=0){
			    		var InstId = gridWest.getSelectionModel().getSelections()[0].get('PHUSDOInstDr');
			    	}
			    }
			    dsUnSelDisea.load({
					params : {
						'InstId':InstId,
						diseaStr:diseaStr, //2016-08-09
						start : 0,
						limit : pageSize_Disea
					}
			    });
	        	WinDisea.setPosition(620,0);
	        	WinDisea.show();
	        }  
        }  
	});
		/** ---------特殊人群未选列表内容部分------------* */
	var dsUnSelPopu = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:QUERY_UnSelPopu_URL}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[{ name: 'SPERowId', mapping:'SPERowId',type: 'string'},
	  	{ name: 'SPECode', mapping:'SPECode',type: 'string'},
        { name: 'SPEDesc', mapping:'SPEDesc',type: 'string'}
		]),
		remoteSort: true
    });	
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsUnSelPopu
	});
	dsUnSelPopu.on('beforeload',function(thiz,options){ 
		if(typeof(gridWest)!="undefined"){
	    	if(gridWest.getSelectionModel().getCount()!=0){
	    		var	InstId = gridWest.getSelectionModel().getSelections()[0].get('PHUSDOInstDr');
	    	}
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     InstId:InstId,
		     PopuStr:PopuStr //2016-08-09
		  }   
		)
	});
	dsUnSelPopu.load({
		params : {
			start : 0,
			limit : pageSize_Popu
		},
		callback : function(records, options, success) {
		}
	});
	var UnSelPopuSearch = new Ext.Button({
		id : 'UnSelPopuSearch',
		iconCls : 'icon-search',
		handler : function() {                                 
			gridUnSelPopu.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelPopuText").getValue(),
       			PopuStr:PopuStr //2016-08-09
       		};
			gridUnSelPopu.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_Popu
					}
			});
		}
	});	
	var UnSelPopuRefresh = new Ext.Button({
		id : 'UnSelPopuRefresh',
		iconCls : 'icon-refresh',
		handler : function() {
			Ext.getCmp("UnSelPopuText").reset();                    
			gridUnSelPopu.getStore().baseParams={PopuStr:PopuStr};//2016-08-09
			gridUnSelPopu.getStore().load({                           
				params : {
					start : 0,
					limit : pageSize_Popu
				}
			});
		}
	});	
	var UnSelPopuText = new Ext.BDP.FunLib.Component.TextField({
		id : 'UnSelPopuText',
		enableKeyEvents : true,
		width:150,
		listeners : {
       	'keyup' : function(field, e){
       		gridUnSelPopu.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelPopuText").getValue(),
       			PopuStr:PopuStr //2016-08-09
       		};
			gridUnSelPopu.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_Popu
					}
				});
	        }
		}						
	})
	var unSelPoputb = new Ext.Toolbar({
		id : 'unSelPoputb',
		items : [UnSelPopuSearch, UnSelPopuText, '->' ,UnSelPopuRefresh]
	});
	var pagingUnSelPopu= new Ext.PagingToolbar({
            pageSize: pageSize_Popu,
            store: dsUnSelPopu,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pageSize_Popu=this.pageSize;
				         }
		        }
        })	
	var smUnSelPopu = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridUnSelPopu = new Ext.grid.GridPanel({
		id:'gridUnSelPopu',
		closable:true,
	    store: dsUnSelPopu,
	    trackMouseOver: true,
	    columns: [
	            smUnSelPopu,
	            { header: 'SPERowId', width: 200, sortable: true, dataIndex: 'SPERowId',hidden:true }, 
	            { header: '特殊人群代码', width: 200, sortable: true, dataIndex: 'SPECode',hidden:true },
	            { header: '特殊人群描述', width: 200, sortable: true, dataIndex: 'SPEDesc' }
	            ],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		tbar : unSelPoputb, 
		bbar:pagingUnSelPopu,
	    stateId: 'gridUnSelPopu'
	});
	var WinPopu=new Ext.Window({  
        id:'WinPopu',  
        width:240,  
        height:360,        
        autoHeight:false,  
        closeAction:"hide",  
        layout: 'fit',  
        plain: true,  
        title:'特殊人群',  
        items:gridUnSelPopu  
    }); 
	//---特殊人群
	var SpecialPopu = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '特殊人群',
		name : 'SpecialPopu',
		id : 'Popu',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('Popu'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Popu')),
		dataIndex:'SpecialPopu'
	});
	var BtnPopu = new Ext.Button({
		id : 'btnPopu',  
        text : '...',  
        tooltip : '特殊人群未选列表',
        listeners : {  
	        'click' : function() {  
	        	/**特殊人群未选列表加载*/
	        	var InstId="";
			    if(typeof(gridWest)!="undefined"){
			    	if(gridWest.getSelectionModel().getCount()!=0){
			    		var InstId = gridWest.getSelectionModel().getSelections()[0].get('PHUSDOInstDr');
			    	}
			    }
			    dsUnSelPopu.load({
					params : {
						'InstId':InstId,
						PopuStr:PopuStr, //2016-08-09
						start : 0,
						limit : pageSize_Popu
					}
			    });
	        	WinPopu.setPosition(620,0);
	        	WinPopu.show();
	        }  
        }  
	});

	//---用法
	var PHEINInstruc = new Ext.BDP.FunLib.Component.BaseComboBox({
		fieldLabel : '用法',
		name : 'PHEINInstruc',
		id : 'Instruc',
		hiddenName : 'PHEINInstruc',
		width:230,
		labelWidth:90,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('Instruc'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Instruc')),
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		queryParam : "desc",
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		minChars : 0,
		listWidth : 230,
		valueField : 'PHEINRowId',
		displayField : 'PHEINDesc',
		store : new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingInstruc,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'PHEINRowId',
			fields : ['PHEINRowId', 'PHEINDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'PHEINRowId',
				direction : 'ASC'
			}
			
		})
		/*,
		listeners : {
			'blur' : function(){
				text[0]=Ext.getCmp("Instruc").getRawValue()+";";
				Ext.getCmp("PHINSTText").setValue(getStr(text));
			}
		}*/
	});
	//---每日用药次数最小值
	var OneDayTimeMin= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel : '每日用药次数',
		name : 'PHUSDOOneDayTimeMin',
		id : 'OneDayTimeMin',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('OneDayTimeMin'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OneDayTimeMin')),
		dataIndex : 'PHUSDOOneDayTimeMin',
		minValue : 0,
		listeners : {
			'blur' : function(){
				/*if(Ext.getCmp("OneDayTimeMin").getValue()!=""){
					text[1]="每日用药"+Ext.getCmp("OneDayTimeMin").getValue();
				}
				Ext.getCmp("PHINSTText").setValue(getStr(text));*/
				//设置每日用药量最小值
				if ((Ext.getCmp("OneDayTimeMin").getValue()!="")&&(Ext.getCmp("OnceQtyMin").getValue()!="")){
					Ext.getCmp("OneDayQtyMin").setValue(Ext.getCmp("OneDayTimeMin").getValue()*Ext.getCmp("OnceQtyMin").getValue());
				}else{
					Ext.getCmp("OneDayQtyMin").setValue("");
				}
			}
		}	
	});
	//---每日用药次数最大值
	var OneDayTimeMax= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel:'-',
		name : 'PHUSDOOneDayTimeMax',
		id : 'OneDayTimeMax',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('OneDayTimeMax'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OneDayTimeMax')),
		dataIndex : 'PHUSDOOneDayTimeMax',
		minValue : 0,
		listeners : {
			'blur' : function(){
				/*if(Ext.getCmp("OneDayTimeMin").getValue()!=""){
					text[2]="-"+Ext.getCmp("OneDayTimeMax").getValue()+"次;";
				}else{
					text[2]="每日用药"+Ext.getCmp("OneDayTimeMax").getValue()+"次;";
				}
				Ext.getCmp("PHINSTText").setValue(getStr(text));*/
				//设置每日用药量最大值
				if ((Ext.getCmp("OneDayTimeMax").getValue()!="")&&(Ext.getCmp("OnceQtyMax").getValue()!="")){
					Ext.getCmp("OneDayQtyMax").setValue(Ext.getCmp("OneDayTimeMax").getValue()*Ext.getCmp("OnceQtyMax").getValue());
				}else{
					Ext.getCmp("OneDayQtyMax").setValue("");
				}
			}
		}	
	});
	var OneDayTimeUom = new Ext.form.Label({
		fieldLabel:'次',
		labelSeparator:''
	});
	//---单次用药量最小值
	var OnceQtyMin= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel : '单次用药量',
		name : 'PHUSDOOnceQtyMin',
		id : 'OnceQtyMin',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('OnceQtyMin'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OnceQtyMin')),
		dataIndex : 'PHUSDOOnceQtyMin',
		minValue : 0,
		listeners : {
			'blur' : function(){
				/*if(Ext.getCmp("OnceQtyMin").getValue()!=""){
					text[3]="单次用药"+Ext.getCmp("OnceQtyMin").getValue();
				}
				Ext.getCmp("PHINSTText").setValue(getStr(text));*/
				//设置每日用药量最小值
				if ((Ext.getCmp("OneDayTimeMin").getValue()!="")&&(Ext.getCmp("OnceQtyMin").getValue()!="")){
					Ext.getCmp("OneDayQtyMin").setValue(Ext.getCmp("OneDayTimeMin").getValue()*Ext.getCmp("OnceQtyMin").getValue());
				}else{
					Ext.getCmp("OneDayQtyMin").setValue("");
				}
			}
		}	
	});
	//---单次用药量最大值
	var OnceQtyMax= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel:'-',
		name : 'PHUSDOOnceQtyMax',
		id : 'OnceQtyMax',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('OnceQtyMax'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OnceQtyMax')),
		dataIndex : 'PHUSDOOnceQtyMax',
		minValue : 0,
		listeners : {
			'blur' : function(){
				/*if(Ext.getCmp("OnceQtyMin").getValue()!=""){
					text[4]="-"+Ext.getCmp("OnceQtyMax").getValue();
				}else{
					text[4]="单次用药"+Ext.getCmp("OnceQtyMax").getValue();
				}
				Ext.getCmp("PHINSTText").setValue(getStr(text));*/
				//设置每日用药量最大值
				if ((Ext.getCmp("OneDayTimeMax").getValue()!="")&&(Ext.getCmp("OnceQtyMax").getValue()!="")){
					Ext.getCmp("OneDayQtyMax").setValue(Ext.getCmp("OneDayTimeMax").getValue()*Ext.getCmp("OnceQtyMax").getValue());
				}else{
					Ext.getCmp("OneDayQtyMax").setValue("");
				}
			}
		}	
	});
	//---单次用药量单位
	var OnceQtyUomDr = new Ext.BDP.FunLib.Component.BaseComboBox({
		fieldLabel:'&nbsp',
		name : 'PHUSDOOnceQtyUomDr',
		id : 'OnceQtyUomDr',
		hiddenName : 'PHUSDOOnceQtyUomDr',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('OnceQtyUomDr'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OnceQtyUomDr')),
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		queryParam : "desc",
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		minChars : 0,
		listWidth : 230,
		valueField : 'PHEURowId',
		displayField : 'PHEUDesc',
		store : new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingUom,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'PHEURowId',
			fields : ['PHEURowId', 'PHEUDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'PHEURowId',
				direction : 'ASC'
			}
		}),
		listeners : {
			'blur' : function(){
				/*text[5]=Ext.getCmp("OnceQtyUomDr").getRawValue()+";";
				Ext.getCmp("PHINSTText").setValue(getStr(text));*/
				Ext.getCmp("OneDayQtyUomDr").setValue(Ext.getCmp("OnceQtyUomDr").getValue());
			}
		}	
	});
	//---每日用药总量最小值
	var OneDayQtyMin= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel : '每日用药总量',
		name : 'PHUSDOOneDayQtyMin',
		id : 'OneDayQtyMin',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('OneDayQtyMin'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OneDayQtyMin')),
		dataIndex : 'PHUSDOOneDayQtyMin',
		minValue : 0/*,
		listeners : {
			'blur' : function(){
				if(Ext.getCmp("OneDayQtyMin").getValue()!=""){
					text[6]="每日用药总量"+Ext.getCmp("OneDayQtyMin").getValue();
				}
				Ext.getCmp("PHINSTText").setValue(getStr(text));
			}
		}	*/
	});
	//---每日用药总量最大值
	var OneDayQtyMax= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel:'-',
		name : 'PHUSDOOneDayQtyMax',
		id : 'OneDayQtyMax',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('OneDayQtyMax'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OneDayQtyMax')),
		dataIndex : 'PHUSDOOneDayQtyMax',
		minValue : 0/*,
		listeners : {
			'blur' : function(){
				if(Ext.getCmp("OneDayQtyMin").getValue()!=""){
					text[7]="-"+Ext.getCmp("OneDayQtyMax").getValue();
				}else{
					text[7]="每日用药总量"+Ext.getCmp("OneDayQtyMax").getValue();				
				}
				Ext.getCmp("PHINSTText").setValue(getStr(text));
			}
		}	*/
	});
	//---每日用药总量单位
	var OneDayQtyUomDr = new Ext.BDP.FunLib.Component.BaseComboBox({
		fieldLabel:'&nbsp',
		name : 'PHUSDOOneDayQtyUomDr',
		id : 'OneDayQtyUomDr',
		hiddenName : 'PHUSDOOneDayQtyUomDr',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('OneDayQtyUomDr'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OneDayQtyUomDr')),
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		queryParam : "desc",
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		minChars : 0,
		listWidth : 230,
		valueField : 'PHEURowId',
		displayField : 'PHEUDesc',
		store : new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingUom,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'PHEURowId',
			fields : ['PHEURowId', 'PHEUDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'PHEURowId',
				direction : 'ASC'
			}
		})/*,
		listeners : {
			'blur' : function(){
				text[8]=Ext.getCmp("OneDayQtyUomDr").getRawValue()+";";
				Ext.getCmp("PHINSTText").setValue(getStr(text));
			}
		}	*/
	});
	//---首次用药量最小值
	var FristTimeQtyMin= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel : '首次用药量',
		name : 'PHUSDOFristTimeQtyMin',
		id : 'FristTimeQtyMin',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('FristTimeQtyMin'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('FristTimeQtyMin')),
		dataIndex : 'PHUSDOFristTimeQtyMin',
		minValue : 0
	});
	//---首次用药量最大值
	var FristTimeQtyMax= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel:'-',
		name : 'PHUSDOFristTimeQtyMax',
		id : 'FristTimeQtyMax',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('FristTimeQtyMax'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('FristTimeQtyMax')),
		dataIndex : 'PHUSDOFristTimeQtyMax',
		minValue : 0
	});
	//---首次用药量单位
	var FristTimeQtyUomDr = new Ext.BDP.FunLib.Component.BaseComboBox({
		fieldLabel:'&nbsp',
		name : 'PHUSDOFristTimeQtyUomDr',
		id : 'FristTimeQtyUomDr',
		hiddenName : 'PHUSDOFristTimeQtyUomDr',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('FristTimeQtyUomDr'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('FristTimeQtyUomDr')),
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		queryParam : "desc",
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		minChars : 0,
		listWidth : 230,
		valueField : 'PHEURowId',
		displayField : 'PHEUDesc',
		store : new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingUom,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'PHEURowId',
			fields : ['PHEURowId', 'PHEUDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'PHEURowId',
				direction : 'ASC'
			}
		})
	});
	//---连用量最小值
	var DurationQtyMin= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel : '连用量',
		name : 'PHUSDODurationQtyMin',
		id : 'DurationQtyMin',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('DurationQtyMin'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DurationQtyMin')),
		dataIndex : 'PHUSDODurationQtyMin',
		minValue : 0
	});
	//---连用量最大值
	var DurationQtyMax= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel:'-',
		name : 'PHUSDODurationQtyMax',
		id : 'DurationQtyMax',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('DurationQtyMax'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DurationQtyMax')),
		dataIndex : 'PHUSDODurationQtyMax',
		minValue : 0
	});
	//---连用量单位
	var DurationQtyUomDr = new Ext.BDP.FunLib.Component.BaseComboBox({
		fieldLabel:'&nbsp',
		name : 'PHUSDODurationQtyUomDr',
		id : 'DurationQtyUomDr',
		hiddenName : 'PHUSDODurationQtyUomDr',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('DurationQtyUomDr'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DurationQtyUomDr')),
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		queryParam : "desc",
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		minChars : 0,
		listWidth : 230,
		valueField : 'PHEURowId',
		displayField : 'PHEUDesc',
		store : new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingUom,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'PHEURowId',
			fields : ['PHEURowId', 'PHEUDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'PHEURowId',
				direction : 'ASC'
			}
		})
	});
	//---用药间隔最小值
	var SpaceQtyMin= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel : '用药间隔',
		name : 'PHUSDOSpaceQtyMin',
		id : 'SpaceQtyMin',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SpaceQtyMin'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SpaceQtyMin')),
		dataIndex : 'PHUSDOSpaceQtyMin',
		minValue : 0
	});
	//---用药间隔最大值
	var SpaceQtyMax= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel:'-',
		name : 'PHUSDOSpaceQtyMax',
		id : 'SpaceQtyMax',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SpaceQtyMax'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SpaceQtyMax')),
		dataIndex : 'PHUSDOSpaceQtyMax',
		minValue : 0
	});
	//---用药间隔单位
	var SpaceQtyUomDr = new Ext.BDP.FunLib.Component.BaseComboBox({
		fieldLabel:'&nbsp',
		name : 'PHUSDOSpaceQtyUomDr',
		id : 'SpaceQtyUomDr',
		hiddenName : 'PHUSDOSpaceQtyUomDr',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SpaceQtyUomDr'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SpaceQtyUomDr')),
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		queryParam : "desc",
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		minChars : 0,
		listWidth : 230,
		valueField : 'PHEURowId',
		displayField : 'PHEUDesc',
		store : new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingUom,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'PHEURowId',
			fields : ['PHEURowId', 'PHEUDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'PHEURowId',
				direction : 'ASC'
			}
		})
	});
	//---每次最大量
	var OnceMaxQty= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel : '每次最大量',
		name : 'PHUSDOOnceMaxQty',
		id : 'OnceMaxQty',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('OnceMaxQty'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OnceMaxQty')),
		dataIndex : 'PHUSDOOnceMaxQty',
		minValue : 0
	});
	//---每次最大量单位
	var OnceMaxQtyUomDr = new Ext.BDP.FunLib.Component.BaseComboBox({
		name : 'PHUSDOOnceMaxQtyUomDr',
		id : 'OnceMaxQtyUomDr',
		hiddenName : 'PHUSDOOnceMaxQtyUomDr',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('OnceMaxQtyUomDr'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OnceMaxQtyUomDr')),
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		queryParam : "desc",
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		minChars : 0,
		listWidth : 230,
		valueField : 'PHEURowId',
		displayField : 'PHEUDesc',
		store : new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingUom,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'PHEURowId',
			fields : ['PHEURowId', 'PHEUDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'PHEURowId',
				direction : 'ASC'
			}
		})
	});
	//---每日最大量
	var OneDayMaxQty= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel : '每日最大量',
		name : 'PHUSDOOneDayMaxQty',
		id : 'OneDayMaxQty',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('OneDayMaxQty'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OneDayMaxQty')),
		dataIndex : 'PHUSDOOneDayMaxQty',
		minValue : 0
	});
	//---每日最大量单位
	var OneDayMaxQtyUomDr = new Ext.BDP.FunLib.Component.BaseComboBox({
		name : 'PHUSDOOneDayMaxQtyUomDr',
		id : 'OneDayMaxQtyUomDr',
		hiddenName : 'PHUSDOOneDayMaxQtyUomDr',
		width:230,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('OneDayMaxQtyUomDr'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OneDayMaxQtyUomDr')),
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		queryParam : "desc",
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		minChars : 0,
		listWidth : 230,
		valueField : 'PHEURowId',
		displayField : 'PHEUDesc',
		store : new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingUom,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'PHEURowId',
			fields : ['PHEURowId', 'PHEUDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'PHEURowId',
				direction : 'ASC'
			}
		})
	});
	//---疗程
	var Period= new Ext.form.TextField({ 
		fieldLabel : '疗程',
		name : 'PHUSDOPeriod',
		id : 'Period',
		width:230,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('Period'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Period')),
		dataIndex : 'PHUSDOPeriod'
	});
	//---年龄
	var PDAAge = new Ext.BDP.FunLib.Component.BaseComboBox({
		fieldLabel : '年龄',
		name : 'PDAAge',
		id : 'Age',
		hiddenName : 'PDAAge',
		width:248,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('Age'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Age')),
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		queryParam : "desc",
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		minChars : 0,
		listWidth : 230,
		valueField : 'PDARowID',
		displayField : 'PDAAgeDesc',
		store : new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingAge,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'PDARowID',
			fields : ['PDARowID', 'PDAAgeDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'PDARowID',
				direction : 'ASC'
			}
		}),
		listeners : {
			'select' : function(){
				var PDARowId=Ext.getCmp("Age").getValue()
				if(PDARowId!=""){
					Ext.Ajax.request({											
					url:AGE_ACTION_URL,
					method:'GET', 
					params:{
						'id':PDARowId
						},
					callback:function(options,success,response){
							    if(success){	
							    var jsonData=Ext.util.JSON.decode(response.responseText);
	    				 		var PDAAgeMin=jsonData.PDAAgeMin;
	    				 		Ext.getCmp("PDAMinValF").setValue(PDAAgeMin);
	    				 		var PDAAgeMax=jsonData.PDAAgeMax;
	    				 		Ext.getCmp("PDAMaxValF").setValue(PDAAgeMax);
	    				 		var PDAUomDr=jsonData.PDAUomDr;
	    				 		Ext.getCmp("PDAUomDrF").setValue(PDAUomDr);
	  						 }
						}
					})	
				}		
				/*text[9]=Ext.getCmp("Age").getRawValue()+";";
				Ext.getCmp("PHINSTText").setValue(getStr(text));*/
			}
		}	
	});
	//---年龄最小值
	var AgeMinVal= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel : '年龄限制',
		name : 'PDAMinVal',
		id : 'PDAMinValF',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDAMinValF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDAMinValF')),
		dataIndex : 'PDAMinVal',
		minValue : 0,
		minText : '不能小于0',
		nanText : '只能是数字'
	});
	//---年龄最大值
	var AgeMaxVal= new Ext.BDP.FunLib.Component.NumberField({ 
		name : 'PDAMaxVal',
		id : 'PDAMaxValF',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDAMaxValF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDAMaxValF')),
		dataIndex : 'PDAMaxVal',
		minValue : 0,
		minText : '不能小于0',
		nanText : '只能是数字'
	});
	//---年龄单位
	var PDAUomDr = new Ext.BDP.FunLib.Component.BaseComboBox({
		name : 'PDAUomDr',
		id : 'PDAUomDrF',
		hiddenName : 'PDAUomDr',
		width:230,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDAUomDrF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDAUomDrF')),
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		queryParam : "desc",
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		minChars : 0,
		listWidth : 230,
		valueField : 'PHEURowId',
		displayField : 'PHEUDesc',
		store : new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingAgeUom,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'PHEURowId',
			fields : ['PHEURowId', 'PHEUDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'PHEURowId',
				direction : 'ASC'
			}
		})
	});
	//性别
	var PHINSTSex=new Ext.BDP.FunLib.Component.RadioGroup({
		id:'Sex',
        fieldLabel:'性别',   
        columns:3,//3列   
        width:350,
        items:[   
            {id:'sexm',boxLabel:'男',name:'PHINSTSex',inputValue:'M'},   
            {id:'sexf',boxLabel:'女',name:'PHINSTSex',inputValue:'F'},
            {id:'sexa',boxLabel:'全部',name:'PHINSTSex',inputValue:'A',checked:true}  
        ]
	});
	//---体重最小值
	var WeightMin= new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : '体重',
		name : 'PHUSDOWeightMin',
		id : 'WeightMin',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('WeightMin'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('WeightMin')),
		dataIndex : 'PHUSDOWeightMin'
	});
	//---体重最大值
	var WeightMax= new Ext.BDP.FunLib.Component.TextField({ 
		name : 'PHUSDOWeightMax',
		id : 'WeightMax',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('WeightMax'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('WeightMax')),
		dataIndex : 'PHUSDOWeightMax'
	});
	//---体表面积最小值
	var BodyAreaMin= new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : '体表面积',
		name : 'PHUSDOBodyAreaMin',
		id : 'BodyAreaMin',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('BodyAreaMin'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BodyAreaMin')),
		dataIndex : 'PHUSDOBodyAreaMin'
	});
	//---体表面积最大值
	var BodyAreaMax= new Ext.BDP.FunLib.Component.TextField({ 
		name : 'PHUSDOBodyAreaMax',
		id : 'BodyAreaMax',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('BodyAreaMax'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BodyAreaMax')),
		dataIndex : 'PHUSDOBodyAreaMax'
	});
	//---特殊人群
	/*
	var CheckboxItems = [];  
	var SpecJson = tkMakeServerCall("web.DHCBL.KB.DHCSpecialPopu","GetSpecJson","","");
	var Spec = SpecJson.split(",");
	for (var i = 0; i < Spec.length-1; i++) {    
        var popu = Spec[i];    
        var box = popu.split("^");
        CheckboxItems.push({    
            boxLabel :box[1],    
            name : "SpecialPopu",
            inputValue : box[0]
         }); 
	}
	if(Spec.length-1==0){
		 CheckboxItems.push({})
	}
	var SpecialPopu=new Ext.BDP.FunLib.Component.CheckboxGroup({
		fieldLabel : '特殊人群',
		name : 'SpecialPopu',
		id : 'Popu',
		columns: 3,
		width:350,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('Popu'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Popu')),
		items : CheckboxItems 
	});
	if(Spec.length-1==0){
		Ext.getCmp('Popu').hidden=true
	}*/
	//---检验项目
	var LABILabDr = new Ext.BDP.FunLib.Component.BaseComboBox({
		fieldLabel:'检验项目',
		name : 'LABILabDr',
		id : 'LabDr',
		hiddenName : 'LABILabDr',
		width:280,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('LabDr'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LabDr')),
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		queryParam : "desc",
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		minChars : 0,
		listWidth : 230,
		valueField : 'PHEGRowId',
		displayField : 'PHEGDesc',
		store : new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingGen,
			baseParams:{code:'LAB'},
			root : 'data',
			totalProperty : 'total',
			idProperty : 'PHEGRowId',
			fields : ['PHEGRowId', 'PHEGDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'PHEGRowId',
				direction : 'ASC'
			}
		}),
		listeners:{
			'select':function(){
				if(Ext.getCmp('LabDr').getValue()!=""){
					Ext.getCmp('LABIRelationF').enable();
					Ext.getCmp('LABIMinVal').enable();
					Ext.getCmp('LABIMaxVal').enable();
					Ext.getCmp('UomDr').enable();
				}
			},
			'blur':function(){
				if(Ext.getCmp('LabDr').getValue()==""){
					Ext.getCmp('LABIRelationF').disable();
					Ext.getCmp('LABIMinVal').disable();
					Ext.getCmp('LABIMaxVal').disable();
					Ext.getCmp('UomDr').disable();
				}
			}
		}
	});
	//---检验项目逻辑
	var LABIRelation = new Ext.BDP.FunLib.Component.BaseComboBox({
		fieldLabel : '逻辑',
		name : 'LABIRelation',
		hiddenName : 'LABIRelation',
		id:'LABIRelationF',
		disabled:true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('LABIRelationF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LABIRelationF')),
		editable:false,
		width:280,
		mode : 'local',
		triggerAction : 'all',// query
		valueField : 'value',
		displayField : 'name',
		store:new Ext.data.SimpleStore({
			fields:['value','name'],
			data:[
				      ['>','大于'],
				      ['<','小于'],
				      ['=','等于'],
				      ['!>','不大于'],
				      ['!<','不小于'],
				      ['<>','不等于']
			     ]
		})
	});
	//---检验指标最小值
	var LABIMinVal= new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : '指标值范围',
		name : 'LABIMinVal',
		id : 'LABIMinVal',
		disabled:true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('LABIMinVal'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LABIMinVal')),
		dataIndex : 'LABIMinVal',
		minValue : 0
	});
	//---检验指标最大值
	var LABIMaxVal= new Ext.BDP.FunLib.Component.TextField({ 
		name : 'LABIMaxVal',
		id : 'LABIMaxVal',
		disabled:true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('LABIMaxVal'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LABIMaxVal')),
		dataIndex : 'LABIMaxVal',
		minValue : 0
	});
	//---检验指标单位
	var LABIUomDr = new Ext.BDP.FunLib.Component.BaseComboBox({
		name : 'LABIUomDr',
		id : 'UomDr',
		hiddenName : 'LABIUomDr',
		width:230,
		disabled:true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('UomDr'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('UomDr')),
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		queryParam : "desc",
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		minChars : 0,
		listWidth : 230,
		valueField : 'PHEURowId',
		displayField : 'PHEUDesc',
		store : new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingUom,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'PHEURowId',
			fields : ['PHEURowId', 'PHEUDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'PHEURowId',
				direction : 'ASC'
			}
		})
	});
	//---提示（医生）
	var DocUseTips= new Ext.BDP.FunLib.Component.TextArea({ 
		fieldLabel : '提示（医生）',
		name : 'PHINSTDocUseTips',
		id : 'DocUseTips',
		width:280,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('DocUseTips'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DocUseTips')),
		dataIndex : 'PHINSTDocUseTips'/*,
		listeners : {
			'blur' : function(){
				if(Ext.getCmp("DocUseTips").getValue()!=""){
					text[10]="提示(医生):"+Ext.getCmp("DocUseTips").getValue()+";";
				}
				Ext.getCmp("PHINSTText").setValue(getStr(text));
			}
		}	*/
	});
	//---提示（护士患者）
	var NurseUseTips= new Ext.BDP.FunLib.Component.TextArea({ 
		fieldLabel : '提示（护士患者）',
		name : 'PHINSTNurseUseTips',
		id : 'NurseUseTips',
		width:280,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('NurseUseTips'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('NurseUseTips')),
		dataIndex : 'PHINSTNurseUseTips'/*,
		listeners : {
			'blur' : function(){
				if(Ext.getCmp("NurseUseTips").getValue()!=""){
					text[11]="提示(护士患者):"+Ext.getCmp("NurseUseTips").getValue();
				}
				Ext.getCmp("PHINSTText").setValue(getStr(text));
			}
		}	*/
	});
	//---描述
	var PHINSTText= new Ext.BDP.FunLib.Component.TextArea({ 
		fieldLabel : '描述',
		name : 'PHINSTText',
		id : 'PHINSTText',
		width:280,
		height:100,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHINSTText'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHINSTText')),
		dataIndex : 'PHINSTText'
	});
	/** ---------病症表单内容部分------------* */
	var dsDisea = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_Disea}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[
	  	{ name: 'PHDDDiseaDr', mapping:'PHDDDiseaDr',type: 'string'},
	  	{ name: 'PHDISLDiseaCode', mapping:'PHDISLDiseaCode',type: 'string'},
        { name: 'PHDISLDiseaDesc', mapping:'PHDISLDiseaDesc',type: 'string'},
        { name: 'PHDDRowId', mapping:'PHDDRowId',type: 'string'}
		]),
		remoteSort: true
    });	
    var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsDisea
	});
	dsDisea.on('beforeload',function(thiz,options){ 
		if(typeof(gridWest)!="undefined"){
	    	if(gridWest.getSelectionModel().getCount()!=0){
	    		var	InstId = gridWest.getSelectionModel().getSelections()[0].get('PHUSDOInstDr');
	    	}
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     InstId:InstId
		  }   
		)
	});
	dsDisea.load({
		params : {
			start : 0,
			limit : pageSize_Disea
		},
		callback : function(records, options, success) {
		}
	});
	var pagingDisea= new Ext.PagingToolbar({
        pageSize: pageSize_Disea,
        store: dsDisea,
        displayInfo: true,
        displayMsg: '',//显示第 {0} 条到 {1} 条记录，一共 {2} 条
        emptyMsg: "",//没有记录
        plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
			listeners : {
			          "change":function (t,p)
			         { 
			             pageSize_Disea=this.pageSize;
			         }
	        }
    });	
	var smDisea = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridDisea = new Ext.grid.GridPanel({
		id:'gridDisea',
		region: 'center',
		title:'病症明细',
		width:400,
		height:180,
		//style:'margin-left:3px', 
		closable:true,
	    store: dsDisea,
	    trackMouseOver: true,
	    columns: [
	            smDisea,
	            { header: 'PHDDDiseaDr', width: 200, sortable: true, dataIndex: 'PHDDDiseaDr',hidden:true },
	            { header: 'PHDDRowId', width: 200, sortable: true, dataIndex: 'PHDDRowId',hidden:true },
	            { header: '病症代码', width: 200, sortable: true, dataIndex: 'PHDISLDiseaCode' },
	            { header: '病症描述', width: 200, sortable: true, dataIndex: 'PHDISLDiseaDesc' }, 
	            {
				header : '操作',
				dataIndex : 'PHDDRowId',
				align:'center',
				renderer:function (){    
			    	var formatStr = '<a href="#" onclick="javascript:return false;" style="color:blue;" >删除</a>';   
     				var resultStr = String.format(formatStr);  
     				return '<div class="delBtn">' + resultStr + '</div>';  
			    }.createDelegate(this)
				}],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		bbar:pagingDisea ,
	    stateId: 'gridDisea'
	});
	gridUnSelDisea.on("rowdblclick", function(grid, rowIndex, e){
		//已选列表新增
		var _record = new Ext.data.Record({
			'PHDDRowId':'',
			'PHDDDiseaDr':gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHDISLRowId'),
	 		'PHDISLDiseaCode':gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaCode'),
	 		'PHDISLDiseaDesc':gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaDesc')
	 	});
	 	gridDisea.stopEditing();
	 	dsDisea.insert(0,_record); 	
	 	
	 	if (diseaStr!=""){
	 		diseaStr=diseaStr+"^<"+gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaCode')+">";
	 	}else{
	 		diseaStr="<"+gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaCode')+">";
	 	}  //2016-08-09
	 	//未选列表删除
	 	var myrecord=gridUnSelDisea.getSelectionModel().getSelected();
	 	dsUnSelDisea.remove(myrecord);
	 	//页面病症框显示值
	 	var diseaDescs="";
	    dsDisea.each(function(record){
	    	if(diseaDescs==""){
	    		diseaDescs = record.get('PHDISLDiseaDesc');
	    	}else{
	    		diseaDescs = diseaDescs+","+record.get('PHDISLDiseaDesc');
	    	}
	    }, this);
	    Ext.getCmp("Disea").setValue(diseaDescs);
	});
	gridDisea.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.delBtn');
	 	if(btn){
	 		var PHDDRowId = gridDisea.getSelectionModel().getSelections()[0].get('PHDDRowId');
	 		if(PHDDRowId==""){
	 			//未选列表新增
	 			var _record = new Ext.data.Record({
					'PHDISLRowId':gridDisea.getSelectionModel().getSelections()[0].get('PHDDDiseaDr'),
			 		'PHDISLDiseaCode':gridDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaCode'),
			 		'PHDISLDiseaDesc':gridDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaDesc')
			 	});
			 	gridUnSelDisea.stopEditing();
			 	dsUnSelDisea.insert(0,_record);
			 	
			 	//已选列表删除
			 	diseaStr=diseaStr.replace("<"+gridDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaCode')+">","");//2016-08-09
	 			var myrecord=gridDisea.getSelectionModel().getSelected();
			 	dsDisea.remove(myrecord);
	 			//页面病症框显示值
	 			var diseaDescs="";
			    dsDisea.each(function(record){
			    	if(diseaDescs==""){
			    		diseaDescs = record.get('PHDISLDiseaDesc');
			    	}else{
			    		diseaDescs = diseaDescs+","+record.get('PHDISLDiseaDesc');
			    	}
			    }, this);
			    Ext.getCmp("Disea").setValue(diseaDescs);
	 		}else{
	 			var InstId = gridWest.getSelectionModel().getSelections()[0].get('PHUSDOInstDr');
				Ext.Ajax.request({
					url : DELETE_Disea_URL,
					method : 'POST',
					params : {
						'id' : PHDDRowId
					},
					callback : function(options, success, response) {
						if (success) {
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								var startIndex = grid.getBottomToolbar().cursor;
								var totalnum=grid.getStore().getTotalCount();
								if(totalnum==1){   //修改添加后只有一条，返回第一页
									var startIndex=0
								}
								else if((totalnum-1)%pagesize_main==0)//最后一页只有一条
								{
									var pagenum=grid.getStore().getCount();
									if (pagenum==1){ startIndex=startIndex-pagesize_main;}  //最后一页的时候,不是最后一页则还停留在这一页
								}
								if(gridDisea.getSelectionModel().getCount()!='0'){
									var id = gridDisea.getSelectionModel().getSelections()[0].get('PHDDRowId');
								}
								/**病症未选列表加载*/
							    var _record = new Ext.data.Record({
									'PHDISLRowId':gridDisea.getSelectionModel().getSelections()[0].get('PHDDDiseaDr'),
							 		'PHDISLDiseaCode':gridDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaCode'),
							 		'PHDISLDiseaDesc':gridDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaDesc')
							 	});
							 	gridUnSelDisea.stopEditing();
							 	dsUnSelDisea.insert(0,_record);
						        /**病症明细加载*/
							   var myrecord=gridDisea.getSelectionModel().getSelected();
	 						   dsDisea.remove(myrecord);
	 						   //页面病症框显示值
								var diseaDescs="";
							    dsDisea.each(function(record){
							    	if(diseaDescs==""){
							    		diseaDescs = record.get('PHDISLDiseaDesc');
							    	}else{
							    		diseaDescs = diseaDescs+","+record.get('PHDISLDiseaDesc');
							    	}
							    }, this);
							    Ext.getCmp("Disea").setValue(diseaDescs);
							} else {
								var errorMsg = '';
								if (jsonData.info) {
									errorMsg = '<br/>错误信息:' + jsonData.info
								}
								Ext.Msg.show({
										title : '提示',
										msg : '数据删除失败!' + errorMsg,
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
								}
						} else {
							Ext.Msg.show({
								title : '提示',
								msg : '异步通讯失败,请检查网络连接!',
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK
							});
						}
					}
				}, this);
	 		}
	 	}
	});
		/** ---------特殊人群表单内容部分------------* */
	var dsPopu = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_Popu}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[
	  	{ name: 'SPEPISpecDr', mapping:'SPEPISpecDr',type: 'string'},
	  	{ name: 'SPECode', mapping:'SPECode',type: 'string'},
        { name: 'SPEDesc', mapping:'SPEDesc',type: 'string'},
        { name: 'SPEPIRowId', mapping:'SPEPIRowId',type: 'string'}
		]),
		remoteSort: true
    });	
    var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsPopu
	});
	dsPopu.on('beforeload',function(thiz,options){ 
		if(typeof(gridWest)!="undefined"){
	    	if(gridWest.getSelectionModel().getCount()!=0){
	    		var	InstId = gridWest.getSelectionModel().getSelections()[0].get('PHUSDOInstDr');
	    	}
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     InstId:InstId
		  }   
		)
	});
	dsPopu.load({
		params : {
			start : 0,
			limit : pageSize_Popu
		},
		callback : function(records, options, success) {
		}
	});
	var pagingPopu= new Ext.PagingToolbar({
        pageSize: pageSize_Popu,
        store: dsPopu,
        displayInfo: true,
        displayMsg: '',//显示第 {0} 条到 {1} 条记录，一共 {2} 条
        emptyMsg: "",//没有记录
        plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
			listeners : {
			          "change":function (t,p)
			         { 
			             pageSize_Popu=this.pageSize;
			         }
	        }
    });	
	var smPopu = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridPopu = new Ext.grid.GridPanel({
		id:'gridPopu',
		region: 'center',
		title:'特殊人群明细',
		width:400,
		height:180,
		//style:'margin-left:3px', 
		closable:true,
	    store: dsPopu,
	    trackMouseOver: true,
	    columns: [
	            smPopu,
	            { header: 'SPEPISpecDr', width: 200, sortable: true, dataIndex: 'SPEPISpecDr',hidden:true },
	            { header: 'SPEPIRowId', width: 200, sortable: true, dataIndex: 'SPEPIRowId',hidden:true },
	            { header: '特殊人群代码', width: 200, sortable: true, dataIndex: 'SPECode' },
	            { header: '特殊人群描述', width: 200, sortable: true, dataIndex: 'SPEDesc' }, 
	            {
				header : '操作',
				dataIndex : 'SPEPIRowId',
				align:'center',
				renderer:function (){    
			    	var formatStr = '<a href="#" onclick="javascript:return false;" style="color:blue;" >删除</a>';   
     				var resultStr = String.format(formatStr);  
     				return '<div class="delBtn">' + resultStr + '</div>';  
			    }.createDelegate(this)
				}],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		bbar:pagingPopu ,
	    stateId: 'gridPopu'
	});
	gridUnSelPopu.on("rowdblclick", function(grid, rowIndex, e){
		//已选列表新增
		var _record = new Ext.data.Record({
			'SPEPIRowId':'',
			'SPEPISpecDr':gridUnSelPopu.getSelectionModel().getSelections()[0].get('SPERowId'),
	 		'SPECode':gridUnSelPopu.getSelectionModel().getSelections()[0].get('SPECode'),
	 		'SPEDesc':gridUnSelPopu.getSelectionModel().getSelections()[0].get('SPEDesc')
	 	});
	 	gridPopu.stopEditing();
	 	dsPopu.insert(0,_record); 	
	 	
	 	if (PopuStr!=""){
	 		PopuStr=PopuStr+"^<"+gridUnSelPopu.getSelectionModel().getSelections()[0].get('SPECode')+">";
	 	}else{
	 		PopuStr="<"+gridUnSelPopu.getSelectionModel().getSelections()[0].get('SPECode')+">";
	 	}  //2016-08-09
	 	//未选列表删除
	 	var myrecord=gridUnSelPopu.getSelectionModel().getSelected();
	 	dsUnSelPopu.remove(myrecord);
	 	//页面特殊人群框显示值
	 	var PopuDescs="";
	    dsPopu.each(function(record){
	    	if(PopuDescs==""){
	    		PopuDescs = record.get('SPEDesc');
	    	}else{
	    		PopuDescs = PopuDescs+","+record.get('SPEDesc');
	    	}
	    }, this);
	    Ext.getCmp("Popu").setValue(PopuDescs);
	});
	gridPopu.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.delBtn');
	 	if(btn){
	 		var SPEPIRowId = gridPopu.getSelectionModel().getSelections()[0].get('SPEPIRowId');
	 		if(SPEPIRowId==""){
	 			//未选列表新增
	 			var _record = new Ext.data.Record({
					'SPERowId':gridPopu.getSelectionModel().getSelections()[0].get('SPEPIRowId'),
			 		'SPECode':gridPopu.getSelectionModel().getSelections()[0].get('SPECode'),
			 		'SPEDesc':gridPopu.getSelectionModel().getSelections()[0].get('SPEDesc')
			 	});
			 	gridUnSelPopu.stopEditing();
			 	dsUnSelPopu.insert(0,_record);
			 	
			 	//已选列表删除
			 	PopuStr=PopuStr.replace("<"+gridPopu.getSelectionModel().getSelections()[0].get('SPECode')+">","");//2016-08-09
	 			var myrecord=gridPopu.getSelectionModel().getSelected();
			 	dsPopu.remove(myrecord);
	 			//页面特殊人群框显示值
	 			var PopuDescs="";
			    dsPopu.each(function(record){
			    	if(PopuDescs==""){
			    		PopuDescs = record.get('SPEDesc');
			    	}else{
			    		PopuDescs = PopuDescs+","+record.get('SPEDesc');
			    	}
			    }, this);
			    Ext.getCmp("Popu").setValue(PopuDescs);
	 		}else{
	 			var InstId = gridWest.getSelectionModel().getSelections()[0].get('PHUSDOInstDr');
				Ext.Ajax.request({
					url : DELETE_Popu_URL,
					method : 'POST',
					params : {
						'id' : SPEPIRowId
					},
					callback : function(options, success, response) {
						if (success) {
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								var startIndex = grid.getBottomToolbar().cursor;
								var totalnum=grid.getStore().getTotalCount();
								if(totalnum==1){   //修改添加后只有一条，返回第一页
									var startIndex=0
								}
								else if((totalnum-1)%pagesize_main==0)//最后一页只有一条
								{
									var pagenum=grid.getStore().getCount();
									if (pagenum==1){ startIndex=startIndex-pagesize_main;}  //最后一页的时候,不是最后一页则还停留在这一页
								}
								if(gridPopu.getSelectionModel().getCount()!='0'){
									var id = gridPopu.getSelectionModel().getSelections()[0].get('SPEPIRowId');
								}
								/**特殊人群未选列表加载*/
							    var _record = new Ext.data.Record({
									'SPERowId':gridPopu.getSelectionModel().getSelections()[0].get('SPEPISpecDr'),
							 		'SPECode':gridPopu.getSelectionModel().getSelections()[0].get('SPECode'),
							 		'SPEDesc':gridPopu.getSelectionModel().getSelections()[0].get('SPEDesc')
							 	});
							 	gridUnSelPopu.stopEditing();
							 	dsUnSelPopu.insert(0,_record);
						        /**特殊人群明细加载*/
							   var myrecord=gridPopu.getSelectionModel().getSelected();
	 						   dsPopu.remove(myrecord);
	 						   //页面特殊人群框显示值
								var PopuDescs="";
							    dsPopu.each(function(record){
							    	if(PopuDescs==""){
							    		PopuDescs = record.get('SPEDesc');
							    	}else{
							    		PopuDescs = PopuDescs+","+record.get('SPEDesc');
							    	}
							    }, this);
							    Ext.getCmp("Popu").setValue(PopuDescs);
							} else {
								var errorMsg = '';
								if (jsonData.info) {
									errorMsg = '<br/>错误信息:' + jsonData.info
								}
								Ext.Msg.show({
										title : '提示',
										msg : '数据删除失败!' + errorMsg,
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
								}
						} else {
							Ext.Msg.show({
								title : '提示',
								msg : '异步通讯失败,请检查网络连接!',
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK
							});
						}
					}
				}, this);
	 		}
	 	}
	});

	var form = new Ext.form.FormPanel({
		id : 'form',
		title:'用法用量',
		frame:true,
		autoScroll:true,///滚动条
		labelAlign : 'right',
		bodyStyle:'overflow-y:auto;overflow-x:hidden;',
		border:false,
		region: 'center',
		buttonAlign:'center',
		labelWidth : 110,
		reader : new Ext.data.JsonReader({
				root : 'data'
			}, [
				{name : 'PHUSDORowId',mapping : 'PHUSDORowId',type : 'string'},
				{name : 'PHUSDOInstDr',mapping : 'PHUSDOInstDr',type : 'string'},
				{name : 'PHINSTMode',mapping : 'PHINSTMode',type : 'string'},//级别
				{name : 'PHDISLDisea',mapping : 'PHDISLDisea',type : 'string'},//病症
				{name : 'PHEINInstruc',mapping : 'PHEINInstruc',type : 'string'},//用法
				//录入用量开始
				{name : 'PHUSDOOneDayTimeMin',mapping : 'PHUSDOOneDayTimeMin',type : 'string'},
				{name : 'PHUSDOOneDayTimeMax',mapping : 'PHUSDOOneDayTimeMax',type : 'string'},
				{name : 'PHUSDOOnceQtyMin',mapping : 'PHUSDOOnceQtyMin',type : 'string'},
				{name : 'PHUSDOOnceQtyMax',mapping : 'PHUSDOOnceQtyMax',type : 'string'},
				{name : 'PHUSDOOnceQtyUomDr',mapping : 'PHUSDOOnceQtyUomDr',type : 'string'},
				{name : 'PHUSDOOneDayQtyMin',mapping : 'PHUSDOOneDayQtyMin',type : 'string'},
				{name : 'PHUSDOOneDayQtyMax',mapping : 'PHUSDOOneDayQtyMax',type : 'string'},
				{name : 'PHUSDOOneDayQtyUomDr',mapping : 'PHUSDOOneDayQtyUomDr',type : 'string'},
				{name : 'PHUSDOOnceMaxQty',mapping : 'PHUSDOOnceMaxQty',type : 'string'},
				{name : 'PHUSDOOnceMaxQtyUomDr',mapping : 'PHUSDOOnceMaxQtyUomDr',type : 'string'},
				{name : 'PHUSDOOneDayMaxQty',mapping : 'PHUSDOOneDayMaxQty',type : 'string'},
				{name : 'PHUSDOOneDayMaxQtyUomDr',mapping : 'PHUSDOOneDayMaxQtyUomDr',type : 'string'},
				{name : 'PHUSDOFristTimeQtyMin',mapping : 'PHUSDOFristTimeQtyMin',type : 'string'},
				{name : 'PHUSDOFristTimeQtyMax',mapping : 'PHUSDOFristTimeQtyMax',type : 'string'},
				{name : 'PHUSDOFristTimeQtyUomDr',mapping : 'PHUSDOFristTimeQtyUomDr',type : 'string'},
				{name : 'PHUSDODurationQtyMin',mapping : 'PHUSDODurationQtyMin',type : 'string'},
				{name : 'PHUSDODurationQtyMax',mapping : 'PHUSDODurationQtyMax',type : 'string'},
				{name : 'PHUSDODurationQtyUomDr',mapping : 'PHUSDODurationQtyUomDr',type : 'string'},
				{name : 'PHUSDOSpaceQtyMin',mapping : 'PHUSDOSpaceQtyMin',type : 'string'},
				{name : 'PHUSDOSpaceQtyMax',mapping : 'PHUSDOSpaceQtyMax',type : 'string'},
				{name : 'PHUSDOSpaceQtyUomDr',mapping : 'PHUSDOSpaceQtyUomDr',type : 'string'},
				{name : 'PHUSDOPeriod',mapping : 'PHUSDOPeriod',type : 'string'},
				//录入用量结束
				{name : 'PDAAge',mapping : 'PDAAge',type : 'string'},//年龄
				{name : 'PDAMinVal',mapping : 'PDAMinVal',type : 'string'},//年龄最小值
				{name : 'PDAMaxVal',mapping : 'PDAMaxVal',type : 'string'},//年龄最大值
				{name : 'PDAUomDr',mapping : 'PDAUomDr',type : 'string'},//年龄单位
				{name : 'PHINSTSex',mapping : 'PHINSTSex',type : 'string'},//性别
				{name : 'PHUSDOWeightMin',mapping : 'PHUSDOWeightMin',type : 'string'},//体重
				{name : 'PHUSDOWeightMax',mapping : 'PHUSDOWeightMax',type : 'string'},
				{name : 'PHUSDOBodyAreaMin',mapping : 'PHUSDOBodyAreaMin',type : 'string'},//体表面积
				{name : 'PHUSDOBodyAreaMax',mapping : 'PHUSDOBodyAreaMax',type : 'string'},
				{name : 'ExtIcd',mapping : 'ExtIcd',type : 'string'},//诊断指标
				{name : 'SpecialPopu',mapping : 'SpecialPopu',type : 'string'},//特殊人群
				{name : 'LABILabDr',mapping : 'LABILabDr',type : 'string'},//检验条目
				{name : 'LABIRelation',mapping : 'LABIRelation',type : 'string'},//检验项目关系
				{name : 'LABIMinVal',mapping : 'LABIMinVal',type : 'string'},//检验指标最小值
				{name : 'LABIMaxVal',mapping : 'LABIMaxVal',type : 'string'},//检验指标最大值
				{name : 'LABIUomDr',mapping : 'LABIUomDr',type : 'string'},//检验指标单位
				{name : 'PHINSTDocUseTips',mapping : 'PHINSTDocUseTips',type : 'string'},//提示（医生）
				{name : 'PHINSTNurseUseTips',mapping : 'PHINSTNurseUseTips',type : 'string'},//提示（护士患者）
				{name : 'PHINSTText',mapping : 'PHINSTText',type : 'string'}//描述
		]),
		items:[PHUSDORowId,PHUSDOInstDr,PHINSTMode,PHEINInstruc,
			{
				xtype : 'fieldset',
				title : '病症',
				width:400,
				autoHeight : true,
				style:'margin-left:50px', 
				items:[{layout : 'column',
				border : false,
				items : [{
						width:265,
						layout : 'form',
						labelWidth : 50,
						labelPad : 1,// 默认5
						border : false,
						style:'margin-left:1px', 
						defaults : {
							anchor : '96%',
							xtype : 'textfield',
							msgTarget : 'under'
						},
						items : [PHDISLDisea]
					},{
						width:20,
						layout : 'form',
						labelWidth : 5,
						labelPad : 1,// 默认5
						border : false,
						defaults : {
							anchor : '96%',
							msgTarget : 'under'
						},
						items : [BtnDisea]
					}]},gridDisea]
			},{	xtype : 'fieldset',
				title : '录入用量',
				width:400,
				autoHeight : true,
				style:'margin-left:50px', 
				items : [{
					layout : 'column',
					border : false,
					items : [{
							width : 155,
							layout : 'form',
							labelWidth : 100,
							labelPad : 1,// 默认5
							border : false,
							style:'margin-left:10px', 
							defaults : {
								anchor : '96%',
								xtype : 'textfield',
								msgTarget : 'under'
							},
							items : [OneDayTimeMin,OnceQtyMin,OneDayQtyMin,FristTimeQtyMin,DurationQtyMin,SpaceQtyMin]
						} ,
						   {
							width:55,
							layout : 'form',
							labelWidth : 5,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '96%',
								xtype : 'textfield',
								msgTarget : 'under'
							},
							items : [OneDayTimeMax,OnceQtyMax,OneDayQtyMax,FristTimeQtyMax,DurationQtyMax,SpaceQtyMax]
						},
						
							{
							width: 100,
							layout : 'form',
							labelWidth : 15,
							labelPad : 1,// 默认5
							border : false,
							style:'margin-left:8px', 
							defaults : {
								anchor : '96%',
								msgTarget : 'under'
							},
							items : [OneDayTimeUom,OnceQtyUomDr,OneDayQtyUomDr,FristTimeQtyUomDr,DurationQtyUomDr,SpaceQtyUomDr]
						}]
					},{
					layout : 'column',
					border : false,
					items : [{
							width:217,
							layout : 'form',
							labelWidth : 100,
							labelPad : 1,// 默认5
							border : false,
							style:'margin-left:10px', 
							defaults : {
								anchor : '96%',
								xtype : 'textfield',
								msgTarget : 'under'
							},
							items : [OnceMaxQty,OneDayMaxQty]
						},{
							width:100,
							layout : 'form',
							labelWidth : 15,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '96%',
								msgTarget : 'under'
							},
							items : [OnceMaxQtyUomDr,OneDayMaxQtyUomDr]
						}]
					}]},Period,PDAAge,{
					layout : 'column',
					border : false,
					items:[{
							width:160,
							layout : 'form',
							labelWidth : 80,
							labelPad : 1,// 默认5
							border : false,
							style:'margin-left:33px', 
							defaults : {
								anchor : '96%',
								xtype : 'textfield',
								msgTarget : 'under'
							},
							items : [AgeMinVal]
						},{
							width:10,
							layout : 'form',
							labelWidth : 5,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '96%'
							},
							items : [{xtype:'label',fieldLabel:'-',labelSeparator:''}]
						},{
							width:80,
							layout : 'form',
							labelWidth : 5,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '96%',
								xtype : 'textfield',
								msgTarget : 'under'
							},
							items : [AgeMaxVal]
						},{
							width: 83,
							layout : 'form',
							labelWidth : 15,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '96%',
								msgTarget : 'under'
							},
							items : [PDAUomDr]//{fieldLabel:'岁',labelSeparator:''}
						}]	
				},PHINSTSex,
			{
					layout : 'column',
					border : false,
					items:[{
							width:200,
							layout : 'form',
							labelWidth : 80,
							labelPad : 1,// 默认5
							border : false,
							style:'margin-left:35px', 
							defaults : {
								anchor : '96%',
								xtype : 'textfield',
								msgTarget : 'under'
							},
							items : [WeightMin,BodyAreaMin]
						},{
							width:10,
							layout : 'form',
							labelWidth : 5,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '96%'
							},
							items : [{xtype:'label',fieldLabel:'-',labelSeparator:''
									},{xtype:'label',fieldLabel:'-',labelSeparator:''
									}]
						},{
							width:120,
							layout : 'form',
							labelWidth : 5,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '96%',
								xtype : 'textfield',
								msgTarget : 'under'
							},
							items : [WeightMax,BodyAreaMax]
						}]	
				},{
					xtype : 'fieldset',
					title : '特殊人群',
					width:400,
					autoHeight : true,
					style:'margin-left:50px', 
					items:[{layout : 'column',
					border : false,
					items : [{
							width:265,
							layout : 'form',
							labelWidth : 50,
							labelPad : 1,// 默认5
							border : false,
							style:'margin-left:1px', 
							defaults : {
								anchor : '96%',
								xtype : 'textfield',
								msgTarget : 'under'
							},
							items : [SpecialPopu]
						},{
							width:20,
							layout : 'form',
							labelWidth : 5,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '96%',
								msgTarget : 'under'
							},
							items : [BtnPopu]
						}]},gridPopu]
				}/*,SpecialPopu*/,LABILabDr,LABIRelation,
				{
					layout : 'column',
					border : false,
					items:[{
							width:170,
							layout : 'form',
							labelWidth : 80,
							labelPad : 1,// 默认5
							border : false,
							style:'margin-left:32px', 
							defaults : {
								anchor : '96%',
								xtype : 'textfield',
								msgTarget : 'under'
							},
							items : [LABIMinVal]
						},{
							width:10,
							layout : 'form',
							labelWidth : 5,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '96%'
							},
							items : [{xtype:'label',fieldLabel:'-',labelSeparator:''}]
						},{
							width:90,
							layout : 'form',
							labelWidth : 5,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '96%',
								xtype : 'textfield',
								msgTarget : 'under'
							},
							items : [LABIMaxVal]
						},{
							width:95,
							layout : 'form',
							labelWidth : 10,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '96%',
								msgTarget : 'under'
							},
							items : [LABIUomDr]
						}]	
				},DocUseTips,NurseUseTips,PHINSTText,
				PHINSTTypeDr,PHINSTOrderNum,PHINSTGenDr,PHINSTPointerDr,PHINSTPointerType,PHINSTLibDr,PHINSTActiveFlag,PHINSTSysFlag
			],
		buttons:[
			{
			 text:'添加',
			 width:80,
			 id:'btnAdd',
			 iconCls : 'icon-add',
			 handler : function() {
    			if(form.form.isValid()==false){return;}
    			if(Ext.getCmp('PHINSTText').getValue()==""){//getStr(text)==""
      	 			Ext.Msg.show({ title : '提示', msg : '请填写描述!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          	 		return;
      	 		}
    			//病症赋值
    			var diseastr="";
			    dsDisea.each(function(record){
					if(diseastr==""){
			    		diseastr = record.get('PHDDDiseaDr');
			    	}else{
			    		diseastr = diseastr+","+record.get('PHDDDiseaDr');
			    	}
			    }, this);
			    Ext.getCmp("Disea").setValue(diseastr);
    			//特殊人群赋值
    			var Popustr="";
			    dsPopu.each(function(record){
					if(Popustr==""){
			    		Popustr = record.get('SPEPISpecDr');
			    	}else{
			    		Popustr = Popustr+","+record.get('SPEPISpecDr');
			    	}
			    }, this);
			    Ext.getCmp("Popu").setValue(Popustr);
			    /*
    			var ids="";
			    var popuitems = SpecialPopu.items;    
			    for (var i = 0; i < popuitems.length; i++) {    
			        if (popuitems.itemAt(i).checked) {    
			            if(ids =="") {
			            	ids=popuitems.itemAt(i).inputValue
			            } else {
			            	ids=ids+","+popuitems.itemAt(i).inputValue
			            }
			        }    
			    }*/
			    	Ext.getCmp('PHUSDORowId').setValue("");
					form.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						//params:{'ids':ids},
						success : function(form, action) {
							if (action.result.success == 'true') {
							 	Ext.getCmp('form').form.reset();
							 	//text.length=0;
							 	Ext.getCmp('LABIRelationF').disable();
								Ext.getCmp('LABIMinVal').disable();
								Ext.getCmp('LABIMaxVal').disable();
								Ext.getCmp('UomDr').disable();
								var myrowid = action.result.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												diseaStr=""; //2016-08-09
												PopuStr="";
												gridWest.getStore().load({
													params : {
																'TypeDr':'',
																'GenDr':GenDr,
																'PointerType':PointerType,
																'PointerDr':Pointer,
																start : 0,
																limit : pagesize_main
																//rowid : myrowid
															}
														});
												dsUnSelDisea.load({
													params : {
														'InstId':"",
														diseaStr:diseaStr, //2016-08-09/2016-08-11
														start : 0,
														limit : pageSize_Disea
													}
												});
												WinDisea.hide();
										        dsDisea.load({
													params : {
														'InstId':"",
														start : 0,
														limit : pageSize_Disea
													},
													callback : function(records, options, success) {
													}
											   });
											   dsUnSelPopu.load({
													params : {
														'InstId':"",
														PopuStr:PopuStr,
														start : 0,
														limit : pageSize_Popu
													}
												});
												WinPopu.hide();
										        dsPopu.load({
													params : {
														'InstId':"",
														start : 0,
														limit : pageSize_Popu
													},
													callback : function(records, options, success) {
													}
											   });
											}
								});
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:' + action.result.errorinfo
								}
								Ext.Msg.show({
												title : '提示',
												msg : '添加失败!' + errorMsg,
												minWidth : 200,
												icon : Ext.Msg.ERROR,
												buttons : Ext.Msg.OK
											});
								}
						},
						failure : function(form, action) {
							Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
						}
					})
				}
			},{
				 text:'修改',
				 width:80,
				 id:'btnUpdate',
				 iconCls : 'icon-update',
				 handler:function(){
				 	if(Ext.getCmp('PHINSTText').getValue()==""){//getStr(text)==""
	      	 			Ext.Msg.show({ title : '提示', msg : '请填写描述!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
	          	 		return;
	      	 		}
				 	//病症赋值
	    			var diseastr="";
				    dsDisea.each(function(record){
				    	if (record.get('PHDDRowId')==""){
					    	if(diseastr==""){
					    		diseastr = record.get('PHDDDiseaDr');
					    	}else{
					    		diseastr = diseastr+","+record.get('PHDDDiseaDr');
					    	}
				    	}
				    }, this);
				    Ext.getCmp("Disea").setValue(diseastr);
				 	//特殊人群赋值
				    var Popustr="";
				    dsPopu.each(function(record){
				    	if (record.get('SPEPIRowId')==""){
					    	if(Popustr==""){
					    		Popustr = record.get('SPEPISpecDr');
					    	}else{
					    		Popustr = Popustr+","+record.get('SPEPISpecDr');
					    	}
				    	}
				    }, this);
				    Ext.getCmp("Popu").setValue(Popustr);
				    /*
	    			var ids="";
				    var popuitems = SpecialPopu.items;    
				    for (var i = 0; i < popuitems.length; i++) {    
				        if (popuitems.itemAt(i).checked) {    
				            if(ids =="") {
				            	ids=popuitems.itemAt(i).inputValue
				            } else {
				            	ids=ids+","+popuitems.itemAt(i).inputValue
				            }
				        }    
				    }*/
				   	if (gridWest.selModel.hasSelection()) {
					 	Ext.MessageBox.confirm('提示', '确定要修改该数据吗?', function(btn) {
							if (btn == 'yes') {
								form.form.submit({
									clientValidation : true, // 进行客户端验证
									waitTitle : '提示',
									url : SAVE_ACTION_URL,
									method : 'POST',
									//params:{'ids':ids},
									success : function(form, action) {
										if (action.result.success == 'true') {
											Ext.getCmp('form').form.reset();
											//text.length=0;
										 	Ext.getCmp('form').form.reset();
										 	Ext.getCmp('LABIRelationF').disable();
											Ext.getCmp('LABIMinVal').disable();
											Ext.getCmp('LABIMaxVal').disable();
											Ext.getCmp('UomDr').disable();
											var myrowid = "rowid=" + action.result.id;
											Ext.Msg.show({
															title : '提示',
															msg : '修改成功!',
															icon : Ext.Msg.INFO,
															buttons : Ext.Msg.OK,
															fn : function(btn) {
																diseaStr=""; //2016-08-09/2016-08-11
																PopuStr="";
																gridWest.getStore().load({
																	params : {
																		'TypeDr':'',
																		'GenDr':GenDr,
																		'PointerType':PointerType,
																		'PointerDr':Pointer,
																		start : 0,
																		limit : pagesize_main
																		//rowid : myrowid
																	}
																});
															 	dsUnSelDisea.load({
															 		params : {
															 			'InstId':"",
															 			diseaStr:diseaStr, //2016-08-09
																		start : 0,
																		limit : pageSize_Disea
															 		}
															 	});
																WinDisea.hide();
														        dsDisea.load({
																	params : {
																		'InstId':"",
																		start : 0,
																		limit : pageSize_Disea
																	},
																	callback : function(records, options, success) {
																	}
															   });
															   dsUnSelPopu.load({
															 		params : {
															 			'InstId':"",
															 			PopuStr:PopuStr, //2016-08-09
																		start : 0,
																		limit : pageSize_Popu
															 		}
															 	});
																WinPopu.hide();
														        dsPopu.load({
																	params : {
																		'InstId':"",
																		start : 0,
																		limit : pageSize_Popu
																	},
																	callback : function(records, options, success) {
																	}
															   });
															}
														});
											} else {
												var errorMsg = '';
												if (action.result.errorinfo) {
												errorMsg = '<br/>错误信息:' + action.result.errorinfo
											}
											Ext.Msg.show({
															title : '提示',
															msg : '修改失败!' + errorMsg,
															minWidth : 200,
															icon : Ext.Msg.ERROR,
															buttons : Ext.Msg.OK
														});
											}
									},
									failure : function(form, action) {
										Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
									}
								})
							}
						}, this);
				   	}else{
				   		Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
				   	}
				 }
			 },{
				 text:'删除',
				 width:80,
				 iconCls : 'icon-delete',
				 handler:function(){
				 	if (gridWest.selModel.hasSelection()) {
				 	Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						var gsm = gridWest.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('PHUSDORowId')
							},
							callback : function(options, success, response) {
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.getCmp('form').form.reset();
										//text.length=0;
										Ext.getCmp('LABIRelationF').disable();
										Ext.getCmp('LABIMinVal').disable();
										Ext.getCmp('LABIMaxVal').disable();
										Ext.getCmp('UomDr').disable();
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = gridWest.getBottomToolbar().cursor;
												var totalnum=gridWest.getStore().getTotalCount();
												if(totalnum==1){   //修改添加后只有一条，返回第一页
													var startIndex=0
												}
												else if((totalnum-1)%pagesize_main==0)//最后一页只有一条
												{
													var pagenum=gridWest.getStore().getCount();
													if (pagenum==1){ startIndex=startIndex-pagesize_main;}  //最后一页的时候,不是最后一页则还停留在这一页
												}
												diseaStr=""; //2016-08-09/2016-08-11
												PopuStr="";
												gridWest.getStore().load({
													params : {
														'TypeDr':'',
														'GenDr':GenDr,
														'PointerType':PointerType,
														'PointerDr':Pointer,
														start : 0,
														limit : pagesize_main
														}
												});
												dsUnSelDisea.load({
													params : {
														'InstId':"",
														diseaStr:diseaStr, //2016-08-09
														start : 0,
														limit : pageSize_Disea
													}
												});
												WinDisea.hide();
										        dsDisea.load({
													params : {
														'InstId':"",
														start : 0,
														limit : pageSize_Disea
													},
													callback : function(records, options, success) {
													}
											   });
											   dsUnSelPopu.load({
													params : {
														'InstId':"",
														PopuStr:PopuStr, //2016-08-09
														start : 0,
														limit : pageSize_Popu
													}
												});
												WinPopu.hide();
										        dsPopu.load({
													params : {
														'InstId':"",
														start : 0,
														limit : pageSize_Popu
													},
													callback : function(records, options, success) {
													}
											   });
												}
											});
									} else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:' + jsonData.info
										}
										Ext.Msg.show({
														title : '提示',
														msg : '数据删除失败!' + errorMsg,
														minWidth : 200,
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK
													});
											}
								} else {
									Ext.Msg.show({
													title : '提示',
													msg : '异步通讯失败,请检查网络连接!',
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								}
							}, this);
					}
				}, this);
			} else {
				Ext.Msg.show({
								title : '提示',
								msg : '请选择需要删除的行!',
								icon : Ext.Msg.WARNING,
								buttons : Ext.Msg.OK
							});
						}
				 }
			 },{
				 text:'重置',
				 width:80,
				 iconCls : 'icon-refresh',
				 handler:function(){
				 	Ext.getCmp('form').form.reset();
				 	//text.length=0;
				 	diseaStr=""; //2016-08-09
				 	PopuStr="";
				 	Ext.getCmp('LABIRelationF').disable();
				 	Ext.getCmp('LABIMinVal').disable();
					Ext.getCmp('LABIMaxVal').disable();
					Ext.getCmp('UomDr').disable();
				 	gridWest.getStore().load({
						params : {
							'TypeDr':'',
							'GenDr':GenDr,
							'PointerType':PointerType,
							'PointerDr':Pointer,
							start : 0,
							limit : pagesize_main
							}
					});
					dsUnSelDisea.load({
						params : {
							'InstId':"",
							diseaStr:diseaStr, //2016-08-09
							start : 0,
							limit : pageSize_Disea
						}
					});
					WinDisea.hide();
			        dsDisea.load({
						params : {
							'InstId':"",
							start : 0,
							limit : pageSize_Disea
						},
						callback : function(records, options, success) {
						}
				   });
				   dsUnSelPopu.load({
						params : {
							'InstId':"",
							PopuStr:PopuStr, //2016-08-09
							start : 0,
							limit : pageSize_Popu
						}
					});
					WinPopu.hide();
			        dsPopu.load({
						params : {
							'InstId':"",
							start : 0,
							limit : pageSize_Popu
						},
						callback : function(records, options, success) {
						}
				   });
				 }
			 }]
	});
	/**********************************west***********************************/
	/** grid数据存储 */
	var dsWest = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL}),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'PHINSTText',
							mapping : 'PHINSTText',
							type : 'string'
						},{
							name : 'PHUSDORowId',
							mapping : 'PHUSDORowId',
							type : 'string'
						},{
							name : 'PHUSDOInstDr',
							mapping : 'PHUSDOInstDr',
							type : 'string'
						}
				])
	});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsWest
	});
	dsWest.on('beforeload',function(thiz,options){ 
		Ext.apply(   
		  this.baseParams,   
		  {   
		    'TypeDr':'',
			'GenDr':GenDr,
			'PointerType':PointerType,
			'PointerDr':Pointer
		  }   
		)
	});
	/** grid加载数据 */
	dsWest.load({
		params : {
			start : 0,
			limit : pagesize_main
		},
		callback : function(records, options, success) {
		}
	});
	/** grid分页工具条 */
	var pagingWest = new Ext.PagingToolbar({
		pageSize : pagesize_main,
		store : dsWest,
		displayInfo : true,
		displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
		emptyMsg : "没有记录",
		plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
		listeners : {
			"change":function (t,p) {
				pagesize_main=this.pageSize;
			}
		}
	});
	/** 创建grid */
	var gridWest = new Ext.grid.GridPanel({
		id : 'gridWest',
		region : 'west',
		closable : true,
		store : dsWest,
		trackMouseOver : true,
		split:true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				 {
					header : '描述',
					sortable : true,
					dataIndex : 'PHINSTText'
				},{
					header : 'PHUSDORowId',
					sortable : true,
					dataIndex : 'PHUSDORowId',
					hidden : true
				},{
					header : 'PHUSDOInstDr',
					sortable : true,
					dataIndex : 'PHUSDOInstDr',
					hidden : true
				}],
		stripeRows : true,
		title:'列表',
		width:200,
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		bbar : pagingWest,
		stateId : 'gridWest'
	});
	/**查询单条*/
	 gridWest.on("rowclick", function(grid, rowIndex, e){
	 	var id = gridWest.getSelectionModel().getSelections()[0].get('PHUSDORowId');
	 	var InstId = gridWest.getSelectionModel().getSelections()[0].get('PHUSDOInstDr');
	 	Ext.getCmp("form").getForm().reset();
	 	diseaStr=""; //2016-08-09
	 	PopuStr=""; 
        Ext.getCmp("form").getForm().load({
            url : OPEN_ACTION_URL + '&id=' + id,
            success : function(form,action) {
            	if(action.result.data.PHINSTSex=='M'){
        			Ext.get('sexm').dom.checked=true;
	        	}
	        	if(action.result.data.PHINSTSex=='F'){
	        		Ext.get('sexf').dom.checked=true;
	        	}
	        	if(action.result.data.PHINSTSex=='A'){
	        		Ext.get('sexa').dom.checked=true;
	        	}
	        	if(action.result.data.PHEINInstruc!="")
	        	{
		        	//var Id=Ext.getCmp('Instruc').getValue();
		        	var instrucId=action.result.data.PHEINInstruc;
		        	if(instrucId!="")
	        		{
		        	var instrucDesc = tkMakeServerCall("web.DHCBL.KB.DHCPHExtInstruc","FindDeseById",instrucId);
		        	Ext.getCmp('Instruc').setRawValue(instrucDesc);
		       		}
		        }
				if(action.result.data.LABILabDr!=""){
					Ext.getCmp('LABIRelationF').enable();
					Ext.getCmp('LABIMinVal').enable();
					Ext.getCmp('LABIMaxVal').enable();
					Ext.getCmp('UomDr').enable();
				}else{
					Ext.getCmp('LABIRelationF').disable();
					Ext.getCmp('LABIMinVal').disable();
					Ext.getCmp('LABIMaxVal').disable();
					Ext.getCmp('UomDr').disable();
				}
				/**设置修改时描述的自动生成*/
				/*if(Ext.getCmp("Instruc").getValue()!=""){
					text[0]=Ext.getCmp("Instruc").getRawValue()+";";
				}
				if(Ext.getCmp("OneDayTimeMin").getValue()!=""){
					text[1]="每日用药"+Ext.getCmp("OneDayTimeMin").getValue();
				}
				if(Ext.getCmp("OneDayTimeMax").getValue()!=""){
					if(Ext.getCmp("OneDayTimeMin").getValue()!=""){
						text[2]="-"+Ext.getCmp("OneDayTimeMax").getValue()+"次;";
					}else{
						text[2]="每日用药"+Ext.getCmp("OneDayTimeMax").getValue()+"次;";
					}
				}
				if(Ext.getCmp("OnceQtyMin").getValue()!=""){
					text[3]="单次用药"+Ext.getCmp("OnceQtyMin").getValue();
				}
				if(Ext.getCmp("OnceQtyMax").getValue()!=""){
					if(Ext.getCmp("OnceQtyMin").getValue()!=""){
						text[4]="-"+Ext.getCmp("OnceQtyMax").getValue();
					}else{
						text[4]="单次用药"+Ext.getCmp("OnceQtyMax").getValue();
					}
				}
				if(Ext.getCmp("OnceQtyUomDr").getValue()!=""){
					text[5]=Ext.getCmp("OnceQtyUomDr").getRawValue()+";";
				}
				if(Ext.getCmp("OneDayQtyMin").getValue()!=""){
					text[6]="每日用药总量"+Ext.getCmp("OneDayQtyMin").getValue();
				}
				if(Ext.getCmp("OneDayQtyMax").getValue()!=""){
					if(Ext.getCmp("OneDayQtyMin").getValue()!=""){
						text[7]="-"+Ext.getCmp("OneDayQtyMax").getValue();
					}else{
						text[7]="每日用药总量"+Ext.getCmp("OneDayQtyMax").getValue();				
					}
				}
				if(Ext.getCmp("OneDayQtyUomDr").getValue()!=""){
					text[8]=Ext.getCmp("OneDayQtyUomDr").getRawValue()+";";
				}
				if(Ext.getCmp("Age").getValue()!=""){
					text[9]=Ext.getCmp("Age").getRawValue()+";";
				}
				if(Ext.getCmp("DocUseTips").getValue()!=""){
					text[10]="提示(医生):"+Ext.getCmp("DocUseTips").getValue()+";";
				}
				if(Ext.getCmp("NurseUseTips").getValue()!=""){
					text[11]="提示(护士患者):"+Ext.getCmp("NurseUseTips").getValue();
				}*/
            },
            failure : function(form,action) {
            	Ext.Msg.alert('编辑', '载入失败');
            }
        });
        /**病症未选列表加载*/
        dsUnSelDisea.load({
			params : {
				'InstId':InstId,
				diseaStr:diseaStr, //2016-08-09
				start : 0,
				limit : pageSize_Disea
			}
	   });
        /**病症明细加载*/
        dsDisea.load({
			params : {
				'InstId':InstId,
				start : 0,
				limit : pageSize_Disea
			},
			callback : function(records, options, success) {
			}
	   });
	   /**特殊人群未选列表加载*/
        dsUnSelPopu.load({
			params : {
				'InstId':InstId,
				PopuStr:PopuStr, //2016-08-09
				start : 0,
				limit : pageSize_Popu
			}
	   });
        /**特殊人群明细加载*/
        dsPopu.load({
			params : {
				'InstId':InstId,
				start : 0,
				limit : pageSize_Popu
			},
			callback : function(records, options, success) {
			}
	   });
	 });
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [gridWest,form]
	});
});