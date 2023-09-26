///处方点评主界面JS
///Creator:LiangQiang
///CreatDate:2012-05-20
///

var unitsUrl = 'dhcpha.comment.outmonitor.save.csp';
var waitMask;
var InputStr;
var UpRow;

Ext.onReady(function() {

  Ext.QuickTips.init();// 浮动信息提示
  Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
  Ext.Ajax.timeout = 900000;
  //StartDaTongDll();  //大通合理用药接口
  
 var oneTbar=new Ext.Toolbar({   

 items:[   
  
	 {xtype: 'tbtext',id:'baseDiag',text:'诊断:'},
	 {xtype: 'tbtext',id:'baseInfoDiag',width:'650',text:'',cls:'x-panel-header'}
 
 ]  
 
 }); 
 
 

  
  InitPatInfo();
 
	
     //重新load Tab,并加载数据
  var HrefRefresh = function (){
         
         
        var adm=PatInfo.adm; 

	        
		var p = Ext.getCmp("ToolsTabPanel").getActiveTab();	
		var iframe = p.el.dom.getElementsByTagName("iframe")[0];
		
		if (p.id=="framepaallergy"){
		  iframe.src = p.src + '?PatientID=' + adm +'&EpisodeID='+ adm ;
		}
		
		if (p.id=="framerisquery"){
		 iframe.src = p.src + '?PatientID=' + adm +'&EpisodeID='+ adm ;
		}
		
		if (p.id=="framelabquery"){
		  iframe.src = p.src + '?PatientID=' + adm +'&EpisodeID='+ adm ;
		}
		
		if (p.id=="frameprbrowser"){
		  iframe.src='dhc.epr.public.episodebrowser.csp?EpisodeID='+ adm;
		}	
		
	
		
		//明细
		if (p.id=="frameordquery"){

			 if ((PatInfo.adm==0)&&(PatInfo.wardid==0))return ;
			 var input=adm+"^"+GetListInput();
             FindOrdDetailData(input);

		}
		

		//本次医嘱
		if (p.id=="frameadmordquery"){
		  iframe.src=p.src + '?EpisodeID=' + adm ;
		}
		
		//入院前药说明
		if (p.id=="frameothmedquery"){
		  iframe.src=p.src + '?EpisodeID=' + adm ;
		}
		
   }
   
 	////////////////////////////////////////////////////////////////////////////////////
	
	////////***********************  以下是右边区域        *********************** 
	
	/////////////////////////////////////////////////////////////////////////////////////  
                       
  var OkButton = new Ext.Button({
             width : 65,
             id:"OkButton",
             text: '通过',
             icon:"../scripts/dhcpha/img/update.png",
             listeners:{
                          "click":function(){   
                             
                              CommontOk();
                              
                              }   
             }
             
             
             })
             
  var BadButton = new Ext.Button({
             width : 65,
             id:"BadButton",
             text: '拒绝',
             icon:"../scripts/dhcpha/img/cancel.png",
             listeners:{
                        "click":function(){
                            EditReason();
                        }
             }
             
             })
             
         

       
             
   var ListLogButton = new Ext.Button({
             width : 65,
             id:"ListLogBtn",
             text: '查看日志',
             icon:"../scripts/dhcpha/img/multiref.gif",
             listeners:{
                          "click":function(){   
                             
                              ListLogBtnClick();
                              
                              }   
             }
             
             
             })
             
     var DaTongYDTSButton = new Ext.Button({
             width : 65,
             id:"DaTongYDTSBtn",
             text: '要点提示',
             icon:"../scripts/dhcpha/img/multiref.gif",
             listeners:{
                          "click":function(){   
                             
                              DaTongYDTSBtnClick();
                              
                              }   
             }
             
             
    })
       var DaTongAnalyseButton = new Ext.Button({
             width : 65,
             id:"DaTongAnalyseBtn",
             text: '处方分析',
             icon:"../scripts/dhcpha/img/multiref.gif",
             listeners:{
                          "click":function(){   
                             
                              //DaTongPrescAnalyse();
                              MKPrescAnalyse();
                              
                              }   
             }
             
             
    })          
    
  ///医嘱明细数据table
    
  var sm = new Ext.grid.CheckboxSelectionModel(); 
  var nm = new Ext.grid.RowNumberer();
  var orddetailgridcm = new Ext.grid.ColumnModel([nm,sm,
  
        {header:'合理用药',dataIndex:'druguse',width: 60,menuDisabled :'false',renderer:showMKHMTL},
        {header:'登记号',dataIndex:'patid',width: 90,menuDisabled :'false'},
        {header:'姓名',dataIndex:'patname',width: 60,menuDisabled :'false'},
        {header:'adm',dataIndex:'adm',hidden:'true',ortable:'false'},
        {header:'药品名称',dataIndex:'incidesc',width:250},
        {header:'数量',dataIndex:'qty',width:40},
        {header:'单位',dataIndex:'uomdesc',width:60},
        {header:'剂量',dataIndex:'dosage',width:60},
        {header:'频次',dataIndex:'freq',width:40},
        {header:'规格',dataIndex:'spec',width:80},
        {header:'用法',dataIndex:'instruc',width:80},
        {header:'剂型',dataIndex:'form',width:80},
        {header:'医嘱优先级',dataIndex:'ordpri',width:80},
        {header:'基本药物',dataIndex:'basflag',width:50},
        {header:'医生',dataIndex:'doctor',width:60},
        {header:'医嘱开单日期',dataIndex:'orddate',width:120},
        {header:'医嘱备注',dataIndex:'remark',width:60},
        {header:'厂家',dataIndex:'manf',width:150},
        {header:'单价',dataIndex:'price',width:60},
        {header:'金额',dataIndex:'amt',width:80},
        {header:'orditem',dataIndex:'orditem'},
        {header:'mainflag',dataIndex:'mainflag',hidden:true},
        {header:'colorflag',dataIndex:'colorflag',hidden:true},
        {header:'moeori',dataIndex:'moeori',hidden:true},
        {header:'adm',dataIndex:'adm',hidden:true}
        
   ]);
 
 
    var orddetailgridds = new Ext.data.Store({
		proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'druguse',
	        'patid',
	        'patname',
		    'adm',
            'incidesc',
            'qty',
		    'uomdesc',
		    'dosage',
		    'freq',
		    'spec',
		    'instruc',
		    'form',
		    'ordpri',
		    'basflag',
		    'doctor',
		    'orddate',
		    'remark',
		    'manf',
		    'price',
		    'amt',
		    'orditem',
		    'mainflag',
		    'colorflag',
		    'moeori',
		    'adm'
	    
		]),
		
		

    remoteSort: true
});

     
 var orddetailgridcmPagingToolbar = new Ext.PagingToolbar({	
			store:orddetailgridds,
			pageSize:200,
			//显示右下角信息
			displayInfo:true,
			displayMsg:'当前记录 {0} -- {1} 条 共 {2} 条记录',
		        prevText:"上一页",
			nextText:"下一页",
			refreshText:"刷新",
			lastText:"最后页",
			firstText:"第一页",
			beforePageText:"当前页",
			afterPageText:"共{0}页",
    		        emptyMsg: "没有数据"
	});
 
 
 var orddetailgrid = new Ext.grid.GridPanel({
        
        stripeRows: true,
        region:'center',
        margins:'3 3 3 3', 
        enableColumnMove : false,
	    trackMouseOver: true,
	    stripeRows: true,
        id:'orddetailtbl',
        ds: orddetailgridds,
        cm: orddetailgridcm,
        sm : sm,
        //tbar:[OkButton,"-",BadButton,'-',ListLogButton,'-',DaTongAnalyseButton,'-',DaTongYDTSButton],
        tbar:[OkButton,"-",BadButton,'-',ListLogButton,'-',DaTongAnalyseButton],
        bbar: orddetailgridcmPagingToolbar,
        trackMouseOver:'true'
        

        
    });
  
    orddetailgrid.on('cellclick',OrddetailGridCellClick)  //大通合理用药
    //orddetailgrid.on('mouseup',OrddetailMouseUpClick)  //美康合理用药
    //orddetailgrid.on('celldblclick',OrddetailGridCellDblClick) //美康合理用药
	
	
    orddetailgrid.on('rowclick',function(grid,rowIndex,e){

        var selectedRow = orddetailgridds.data.items[rowIndex];
	var adm = selectedRow.data["adm"];     
        PatInfo.adm=adm;

		
		
    });
    
    
    
	
     ///右边的Form

	
     var toolform = new Ext.TabPanel({
        id:'ToolsTabPanel',
	    region: 'center',
	    margins:'3 3 0 3', 
	    frame:false,
	    activeTab: 0,
            items:[{
            	title: '医嘱明细',	
		id:'frameordquery',
		layout:'border',
		items: [orddetailgrid]
	    },{
	        		title: '过敏记录',	
					frameName: 'framepaallergy',
					html: '<iframe id="paallergyFrame" width=100% height=100% src=dhcpha.comment.paallergy.csp></iframe>',		
					src: 'dhcpha.comment.paallergy.csp',
					id:'framepaallergy'
	
	    },{
	          		title: '检查记录',
	          		frameName: 'framerisquery',
	          		html: '<iframe id="framerisquery" width=100% height=100% src=dhcpha.comment.risquery.csp></iframe>',		
		  			src: 'dhcpha.comment.risquery.csp',
		  			id:'framerisquery'
	       
	
	    },{
	          		title: '检验记录',
	          		frameName: 'framelabquery',
	          		html: '<iframe id="framelabquery" width=100% height=100% src=dhcpha.comment.labquery.csp></iframe>',		
		  			src: 'dhcpha.comment.labquery.csp',
		  			id:'framelabquery'
	       
	
	    },{
	          		title: '病历浏览',
	          		frameName: 'frameprbrowser',
	          		html: '<iframe id="frmeprbrowser" width=100% height=100% src=epr.newfw.episodelistuvpanel.csp></iframe>',		
		  			src: 'epr.newfw.episodelistuvpanel.csp',
		  			id:'frameprbrowser'
	       
	
	    },{
	          		title: '本次医嘱',
	          		frameName: 'frameadmordquery',
	          		html: '<iframe id="frameadmordquery" width=100% height=100% src=dhcpha.comment.admordquery.csp></iframe>',		
		  			src: 'dhcpha.comment.admordquery.csp',
		  			id:'frameadmordquery'
	       
	
	    },{
	          		title: '入院前用药',
	          		frameName: 'frameothmedquery',
	          		html: '<iframe id="frameothmedquery" width=100% height=100% src=dhcpha.comment.othmedquery.csp></iframe>',		
		  			src: 'dhcpha.comment.othmedquery.csp',
		  			id:'frameothmedquery'
	       
	
	    }],

	    
	    listeners:{ 
                              tabchange:function(tp,p){ 
                                          HrefRefresh() ;
                                    } 
                                
                      } 

	    
	    
	  
	    
	    
	});
	


	
	


    toolform.on('afterlayout',function(view,layout){   
	  
	    
	    //toolform.setHeight(document.body.clientHeight)

	    
	},this);
	


	
	////////////////////////////////////////////////////////////////////////////////////
	
	////////***********************  以下是左边区域        *********************** 
	
	/////////////////////////////////////////////////////////////////////////////////////
	
	
	   //刷新
   var  RefreshButton = new Ext.Button({
             width : 70,
             id:"RefreshBtn",
             text: '查询',
             icon:"../scripts/dhcpha/img/find.gif",
             listeners:{
                          "click":function(){   
                             
                                 FindList();
                              
                              }   
             }
             
             
   })
   
   

   //自动刷新
   var AutoRefreshChkbox=new Ext.form.Checkbox({
        
		boxLabel : '自动刷新',
		id : 'AutoRefreshChk',
		inputValue : '1',
		checked : false,
		listeners:{
					'check': function(){
						
						if (Ext.getCmp("AutoRefreshChk").getValue())
						{
							//StartAutoLoadTree();
						}
					        else{
					       
					               //StopAutoLoadTree();
	
						}
					}
	}
    })
    
    
   //仅出院带药
   var OnlyOutChkbox=new Ext.form.Checkbox({
        
		boxLabel : '仅出院带药',
		id : 'OnlyOutChk',
		inputValue : '1',
		checked : false,
		listeners:{
					'check': function(){
	
					}
		}
    })
    
    
   //已审核
   var OnlyAdtChkbox=new Ext.form.Checkbox({
        
		boxLabel : '仅已审',
		id : 'OnlyAdtChk',
		inputValue : '1',
		checked : false,
		listeners:{
					'check': function(){
	
					}
		}
    })
    

	
	 ///病区控件
	var WardDs = new Ext.data.Store({
		autoLoad: true,
		proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=GetWardDs',
			method : 'POST'
		}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['warddesc','rowId'])
				
	});
	
    
    //病区tbar 
    var WardDescSelecter = new Ext.form.ComboBox({
				  id:'WardDescCombox',
				  fieldLabel:'病区',
				  store: WardDs,
				  valueField:'rowId',
				  displayField:'warddesc',
				  width : 120,
				  listWidth:250,
				  emptyText:'选择病区...',
				  mode: 'local'
	
				  
				  		  
				  
	});  
	

	
	
	 //药房科室控件
	
	var phlocInfo = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['phlocdesc','rowId'])
				
	});
	
	phlocInfo.on(
		'beforeload',
		function(ds, o){
		    var grpdr=session['LOGON.GROUPID'] ;
			ds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetStockPhlocDs&GrpDr='+grpdr, method:'GET'});
		
		}
	);
	
	 
	 
	 var PhaLocSelecter = new Ext.form.ComboBox({
				  id:'PhaLocSelecter',
				  fieldLabel:'药房科室',
				  store: phlocInfo,
				  valueField:'rowId',
				  displayField:'phlocdesc',
				  width : 120,
				  listWidth:250,
				  emptyText:'选择药房科室...',
		                  allowBlank: false,
				  name:'PhaLocSelecter',
				  mode: 'local'
				  
				  		  
				  
	});
	
	
		
	//初始化药房科室
	phlocInfo.on("load",function(store,record,opts){ setDefaultLoc(); });
	
	
    //病人登记号查询工具
	patientQueryBar = new  Ext.Toolbar({
		//hidden:true,
		items: ["登记号:", new Ext.form.TwinTriggerField({
			width:160,id:'patientNoTF',enableKeyEvents:true,
			trigger1Class: 'x-form-clear-trigger',
			trigger2Class: 'x-form-search-trigger',
			onTrigger1Click: function(e){
				this.setValue("");
			}
			//onTrigger2Click: findPatientTree
		})]
	});

	
	function hideQueryBar (){
		patientQueryBar.hide();

	}
	
	function showQueryBar(){
		patientQueryBar.show();

	}
	
	
 
	

			
	//病区查询工具
	wardQueryBar = new  Ext.Toolbar({
		hidden:true,
		items: ['病区:',WardDescSelecter]

	});
	
	function hidewardQueryBar (){
		wardQueryBar.hide();
	}
	
	function showwardQueryBar (){
		wardQueryBar.show();
		
	}
	
	
   //展开控件
   var MoreQuery=new Ext.form.Checkbox({
        
		boxLabel : '更多',
		id : 'MoreQueryChk',
		inputValue : '1',
		checked : false,
		listeners:{
					'check': function(){
						ClearMore();
                        if (Ext.getCmp("MoreQueryChk").getValue())
                        {
                        	showwardQueryBar();
                        }
                        else
                        {
                        	hidewardQueryBar();
                        }
					}
		}
    })


   
  var stdatef=new Ext.form.DateField ({
                width : 120,
                xtype: 'datefield',
                format:'j/m/Y' ,
                fieldLabel: '开始日期',
                name: 'startdt',
                id: 'startdt',
                invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
                value:new Date
            })	
            
            
            
  var enddatef=new Ext.form.DateField ({
  	        width : 120,
            format:'j/m/Y' ,
            fieldLabel: '截止日期',
	        name: 'enddt',
	        id: 'enddt',
	        invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
	        value:GetIPEndDate()
            })
    
        var InputStr=GetListInput();
        
     /*   
    
	// 创建一个简写

	var Tree = Ext.tree;

	// 定义根节点的Loader

	var treeloader = new Tree.TreeLoader({

				dataUrl : unitsUrl + '?action=GetAdmTreeData' ,
				requestMethod :'GET' 

			});
			
   	// 异步加载根节点

	var rootnode = new Tree.AsyncTreeNode({

				//text :"请选择方式",

				id : 'id',

				value : '0',

				level : '0',

				draggable : false , // 根节点不容许拖动

				expanded : true

			});

	// 为tree设置根节点

	//treepanel.setRootNode(rootnode);

	// 添加一个树形面板

	var treepanel = new Tree.TreePanel({

				//el : 'tree-panel',// 				
		                root:rootnode,
				//width : 350,
				//minSize : 250,
				//maxSize : 290,
				split : true,
				region:'center',
				margins:'0 0 0 0', 				
				frame : true,
				autoScroll : true,
				enableDD : false,
				containerScroll : true,
				rootVisible : false,
				border : true,
				animate : true,
				loader : treeloader,              
				tbar: [AutoRefreshChkbox,'-',OnlyOutChkbox,'-',MoreQuery],
		
				listeners:{
					'render': function(){
						wardQueryBar.render(treepanel.tbar);			
					}
					
					
					
				}
				
				
				
				
			});

    


	// 响应加载前事件，传递node参数
			
	treeloader.on('beforeload', function(treeloader, node) {
	
				if (node == rootnode) {
					node.attributes.id = '0';
				}

				treeloader.baseParams = {
					id : node.attributes.id, 
					level : node.attributes.level,
					input:InputStr,
					actiontype : 'load'
				}
  			    //StartLoading();
              
		     },

			this);;

   treepanel.expandAll();

   //treeloader.on("load",function(node,response){  EndLoading(); });

   
   // 设置树的点击事件

   treepanel.on('click', treeClick);
	
*/
        
     //查找病人列表控件
	
    var patlistst = new Ext.data.Store({
	    proxy: "",
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	        }, [
	            'patid',
		    'patloc',
		    'bedno',
		    'adm'
			]),
	    // turn on remote sorting
	    remoteSort: true
	});
	    
	  
	  
	  var patlistcm = new Ext.grid.ColumnModel({
	
	    columns: [

	        {header:'登记号',dataIndex:'patid',width: 90,menuDisabled :'false'},
	        {header:'病区',dataIndex:'patloc',width: 160,menuDisabled :'false'},
	        {header:'床号',dataIndex:'bedno',width: 80,menuDisabled :'false'},
	         {header:'adm',dataIndex:'adm',hidden:'true',ortable:'false'}
	       ]
	    });
	    
	 var patlistgridPagingToolbar = new Ext.PagingToolbar({	
				store:patlistst,
				pageSize:200,
				//显示右下角信息
				displayInfo:true,
				displayMsg:'当前记录 {0} -- {1} 条 共 {2} 条记录',
			    prevText:"上一页",
				nextText:"下一页",
				refreshText:"刷新",
				lastText:"最后页",
				firstText:"第一页",
				beforePageText:"当前页",
				afterPageText:"共{0}页",
	    		emptyMsg: "没有数据"
		});
	  
	  var patlistgrid = new Ext.grid.GridPanel({
	        region:'center',
			margins:'0 0 0 0', 
	        enableColumnMove : false,
	        height:480,
	        trackMouseOver: true,
	        stripeRows: true,
	        ds: patlistst,
	        cm: patlistcm,
	        tbar:[],
	        bbar:[patlistgridPagingToolbar],
	        view: new Ext.ux.grid.BufferView({
			    rowHeight: 25,
			    scrollDelay: false
		    
		    }),
	        listeners:{
					'render': function(){
						wardQueryBar.render(patlistgrid.tbar);			
					}
					
					
					
				}
	    });
	    

	///就诊列表grid 单击行事件

    patlistgrid.on('rowclick',function(grid,rowIndex,e){

        var selectedRow = patlistst.data.items[rowIndex];
		var adm = selectedRow.data["adm"];     
        ClearWindow();
        //GetInPatInfo(adm);
        PatInfo.adm=adm;
        HrefRefresh();
        //
		
		
    });   
    
    
    
         //查找病区列表控件
	
    var wardlistst = new Ext.data.Store({
	    proxy: "",
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	        }, [
		    'warddesc',
		    'wardid'
			]),
	    // turn on remote sorting
	    remoteSort: true
	});
	    
	  
	  
	  var wardlistcm = new Ext.grid.ColumnModel({
	
	    columns: [

	        {header:'病区',dataIndex:'warddesc',width: 200,menuDisabled :'false'},
	         {header:'wardid',dataIndex:'wardid',hidden:'true',ortable:'false'}
	       ]
	    });
	    
	 var wardlistgridPagingToolbar = new Ext.PagingToolbar({	
				store:wardlistst,
				pageSize:200,
				//显示右下角信息
				displayInfo:true,
				displayMsg:'当前记录 {0} -- {1} 条 共 {2} 条记录',
			    prevText:"上一页",
				nextText:"下一页",
				refreshText:"刷新",
				lastText:"最后页",
				firstText:"第一页",
				beforePageText:"当前页",
				afterPageText:"共{0}页",
	    		emptyMsg: "没有数据"
		});
	  
	  var wardlistgrid = new Ext.grid.GridPanel({
	        region:'center',
			margins:'0 0 0 0', 
	        enableColumnMove : false,
	        height:480,
	        trackMouseOver: true,
	        stripeRows: true,
	        ds: wardlistst,
	        cm: wardlistcm,
	        view: new Ext.ux.grid.BufferView({
			    rowHeight: 25,
			    scrollDelay: false
		    
		    })
	    });
	    
   		///病区grid 单击行事件

    wardlistgrid.on('rowclick',function(grid,rowIndex,e){

        var selectedRow = wardlistst.data.items[rowIndex];
		var wardid = selectedRow.data["wardid"];
        ClearWindow();
        PatInfo.wardid=wardid;
        HrefRefresh();
        
		
		
    }); 
    
    
	//按登记号查控件
	
    var patinfost = new Ext.data.Store({
	    proxy: "",
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	        }, [
	            'adm',
		    'admloc',
		    'admdate',
		    'currward',
		    'currbed',
		    'currdoc'
			]),
	    // turn on remote sorting
	    remoteSort: true
	});
	    
	  
	  
	  var patinfocm = new Ext.grid.ColumnModel({
	
	    columns: [
	
	        {header:'adm',dataIndex:'adm',hidden:'true',ortable:'false'},
	        {header:'就诊时间',dataIndex:'admdate',width: 80,menuDisabled :'false'},
	        {header:'就诊科室',dataIndex:'admloc',width: 120,menuDisabled :'false'},
	        {header:'病区',dataIndex:'currward',width: 120,menuDisabled :'false'},
	        {header:'床号',dataIndex:'currbed',width: 40,menuDisabled :'false'},
	        {header:'医生',dataIndex:'currdoc',width: 60,menuDisabled :'false'}
	       ]
	    });
	    

		
	     //病人登记号查询工具
	var patientTwin =  new Ext.form.TwinTriggerField({
			width:160,id:'patientNoTF',enableKeyEvents:true,
			trigger1Class: 'x-form-clear-trigger',
			trigger2Class: 'x-form-search-trigger',
			onTrigger1Click: function(e){
				this.setValue("");
				ClearWindow();
			},
			onTrigger2Click: function(e){
				GetAdmDs(this.getValue());
			},
			listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                GetAdmDs(this.getValue());
                            }
                        }
                    }
	});
	  
	  
	  var patinfogrid = new Ext.grid.GridPanel({
	  
	        enableColumnMove : false,
	        height:480,
	        trackMouseOver: true,
	        stripeRows: true,
	        ds: patinfost,
	        cm: patinfocm,
	        tbar:['登记号:',patientTwin]
	    });
	    

	///就诊列表grid 单击行事件

    patinfogrid.on('rowclick',function(grid,rowIndex,e){

        var selectedRow = patinfost.data.items[rowIndex];
		var adm = selectedRow.data["adm"];
                
        ClearWindow();
        //GetInPatInfo(adm);
        PatInfo.adm=adm;
        HrefRefresh();
		
		
    });   
    

		
	//左边tab控件
	var ListTabPanel = new Ext.TabPanel({
        id:'ListTab',
	    frame:false,
	    activeTab: 0,
	    region:'center',
        margins:'0 0 0 0',
	    items:[{
                    title:'病区列表',
					id:'wardlisttab',
					layout:'border', 
					items: [wardlistgrid]
	
	    },{
                    title:'病区/病人列表',
					id:'wardpatlisttab',
					layout:'border', 
					items: [patlistgrid]
	
	    },{
	    	        title:'按登记号查',
	       			id:'patlisttab',
					items: [patinfogrid]
	    }]
	    
	})
	
	
	
	var DatePanel = new Ext.Panel({ 
         frame:true,
         layout:'form' ,
         labelAlign : 'right',
         labelWidth: 75,
         region:'center',
         buttonAlign:'center',
         margins:'0 0 0 0',
         items : [{
					layout : "column",
					items : [{
					            labelAlign : 'right',
								columnWidth : 1,
								layout : "form",
								items : [ PhaLocSelecter ]
							 }]
								   
								   
								   
								   
					},{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [  stdatef  ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [  enddatef  ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [  WardDescSelecter  ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .33,
										layout: {
			                                type: 'hbox',
			                                align: 'middle ',
			                                pack: 'center'
			                            },
										items : [  AutoRefreshChkbox  ]
									 },{ 
							            labelAlign : 'right',
										columnWidth : .33,
										layout: {
			                                type: 'hbox',
			                                align: 'middle ',
			                                pack: 'center'
			                            },
										items : [  OnlyOutChkbox  ]
									 },{ 
							            labelAlign : 'right',
										columnWidth : .33,
										layout: {
			                                type: 'hbox',
			                                align: 'middle ',
			                                pack: 'center'
			                            },
										items : [  OnlyAdtChkbox  ]
									 }]
					  }
					
		 ],
					

         buttons: [RefreshButton]
 
         });
         
   
     var westPanel = new Ext.Panel({
         region: 'west',  
         title: '住院医嘱审核',
         frame:true,
         collapsible: true,
         labelAlign : 'right',
         labelWidth: 75,
         buttonAlign:'center',
	 	 width:310,
	 	 layout:{  
	        type:'vbox', 
	        align: 'stretch',  
	        pack: 'start'  
	     }, 
	     items: [{         
         	  flex: 1,
         	  layout:'border',
         	  items:[DatePanel]  
         	 },{   
         	  flex: 2 ,
         	  layout:'border',
         	  items:[ListTabPanel]    
               }]
 
         });
    


      var port = new Ext.Viewport({

				layout : 'border',
				items : [westPanel,toolform]

			});



			
	////////////////////////////////////////////////////////////////////////////////////
	
	////////***********************  以下是Events区域        *********************** 
	
	/////////////////////////////////////////////////////////////////////////////////////



 

///打开新窗体(更多查询条件)
function OpenMoreFindWindow()
{

   MoreFindFun();
   

   
}




/// 根据Adm查看医嘱明细

function FindOrdDetailData(input)  
{
                waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." }); 
                waitMask.show();
                orddetailgridds.removeAll();
				orddetailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindIPOrdDetailDs&input='+input  });		
				orddetailgridds.load({
				params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize},
				callback: function(r, options, success){
 
		         
		         waitMask.hide();
		         if (success==false){
		                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		         
		
		});
		
				
		
} 


///清PatInfo
function ClearPatInfo()
{
	PatInfo.adm=0;

	Ext.getCmp("baseInfoIPNo").setText('');
	Ext.getCmp("baseInfoName").setText('');
	Ext.getCmp("baseInfoSex").setText('');
	Ext.getCmp("baseInfoAge").setText('');
	Ext.getCmp("baseInfoType").setText('');
	Ext.getCmp("baseInfoLoc").setText('');
	Ext.getCmp("baseInfoWeight").setText('');
	Ext.getCmp("baseInfoDiag").setText('');

		
		
}



///清屏

function ClearWindow()
{
        
		orddetailgridds.removeAll();
		//ClearPatInfo();
        InitPatInfo();
}

function InitPatInfo()
{
		PatInfo =  {
		    adm: 0,
	        patientID:0,
	        episodeID:0,
	        admType:"I",
	        prescno:0,
	        orditem:0,
	        wardid:0
		  }
		
}

///合格

function CommontOk()
{

     
     var orditm = "";
     var ret="Y";
     var reasondr="";
     var advicetxt="";
     var factxt="";
     var phnote="";
     var User=session['LOGON.USERID'] ;
	 var grpdr=session['LOGON.GROUPID'] ;
	 
	 
	 var totalnum =orddetailgrid.getStore().getCount() ;
	 if (totalnum==0){
	    return;
	 }

	 for(var i=0;i<totalnum;i++){
		      
		        var orditm=orddetailgridds.getAt(i).get("orditem") ;
		        var input=ret+"^"+User+"^"+advicetxt+"^"+factxt+"^"+phnote+"^"+grpdr+"^"+orditm;
		        SaveCommontResult(reasondr,input)
	 }
		
		
	 
	 

     
     
     
 
}



///不合格

function EditReason()
{
       
       var detailrow = Ext.getCmp("orddetailtbl").getSelectionModel().getSelections(); 


       if (!(detailrow)){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("提示", "未选中药品记录!");
           return;
       }
       if (detailrow==0){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("提示", "未选中药品记录!");
           return;
       }
       
        
       var orditm = detailrow[0].data.orditem;
       var waycode = "7";
       
    
       var retstr=showModalDialog('dhcpha.comment.selectreason.csp?orditm='+orditm+'&waycode='+waycode,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
        
 
       if (!(retstr)){
          return;
        }
        
        if (retstr==""){
          return;
        }
        
        retarr=retstr.split("@");

        var ret="N";
		var reasondr=retarr[0];
		var advicetxt=retarr[2];
		var factxt=retarr[1];
		var phnote=retarr[3];
		var User=session['LOGON.USERID'] ;
		var grpdr=session['LOGON.GROUPID'] ;
		
		
		var input=ret+"^"+User+"^"+advicetxt+"^"+factxt+"^"+phnote+"^"+grpdr+"^"+orditm;
		
		if (reasondr.indexOf("$$$")=="-1")
		{
			reasondr=reasondr+"$$$"+orditm ;
		}
		
		
		SaveCommontResult(reasondr,input) 
       

}


///保存点评结果

function SaveCommontResult(reasondr,input)
{
        //var currow = ordgrid.getSelectionModel().getSelected();
        //var curdetail=orddetailgrid.getSelectionModel().getSelected();
   
        //var User=session['LOGON.USERID'] ;

        //alert(currow);
        //alert(orditm)
        //alert(reasondr)
        //alert(advicetxt)
        //alert(factxt)
        //
        
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." ,removeMask: true}); 
        waitMask.show();
            
  		Ext.Ajax.request({

	        url:unitsUrl+'?action=SaveItmResultIPMo&Input='+input+'&ReasonDr='+reasondr ,
			failure: function(result, request) {
				waitMask.hide() ;
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
			success: function(result, request) {
	            waitMask.hide() ;
				var jsonData = Ext.util.JSON.decode( result.responseText );
				  		
				//alert(jsonData.retvalue)
				//alert(jsonData.retinfo)	
				
				if (jsonData.retvalue==0){
	
                    HrefRefresh();	
				  
				}else{
				    msgtxt=jsonData.retinfo;

				    Ext.Msg.show({title:'提示',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}			  	 
	  		
	  		

		},
		
			scope: this
		});

    
}




///取病人基本信息

function GetInPatInfo(adm)
{

  		Ext.Ajax.request({

	    url:unitsUrl+'?action=GetInPatInfo&Adm='+adm ,
	
		waitMsg:'处理中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {

			var jsonData = Ext.util.JSON.decode( result.responseText );
			var str=jsonData.retvalue ;	
            if (str!=""){
            	SetPatInfo(str);
            	
            }
	  		

		},
		
			scope: this
		});

    
}


 function SetPatInfo(str)
 	{
 		
 		tmparr=str.split("^");
 		
 		patno=tmparr[0];
 		patname=tmparr[1];
 		patsex=tmparr[3];
 		patage=tmparr[2];
 		pattype=tmparr[11];
 		ward=tmparr[13];
 		weight=tmparr[5];
 		diag=tmparr[4];
 		
		Ext.getCmp("baseInfoIPNo").setText(patno);
		Ext.getCmp("baseInfoName").setText(patname);
		Ext.getCmp("baseInfoSex").setText(patsex);
		Ext.getCmp("baseInfoAge").setText(patage);
		Ext.getCmp("baseInfoType").setText(pattype);
		Ext.getCmp("baseInfoLoc").setText(ward);
		Ext.getCmp("baseInfoWeight").setText(weight);
		Ext.getCmp("baseInfoDiag").setText(diag);

	}
 ///查看日志	
 function ListLogBtnClick()
 {
 	   var detailrow = Ext.getCmp("orddetailtbl").getSelectionModel().getSelections(); 

 	   
       if (!(detailrow)){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("提示", "未选中药品记录!");
           return;
       }
       if (detailrow==0){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("提示", "未选中药品记录!");
           return;
       }
       
       
       var adm=PatInfo.adm;
       var orditm = detailrow[0].data.orditem;
       
       FindItmLog(orditm);
 }
 

	
	
   function ClearGrid()
	{
		Ext.getCmp("baseInfoIPNo").setText('');
		Ext.getCmp("baseInfoName").setText('');
		Ext.getCmp("baseInfoSex").setText('');
		Ext.getCmp("baseInfoAge").setText('');
		Ext.getCmp("baseInfoType").setText('');
		Ext.getCmp("baseInfoLoc").setText('');
		Ext.getCmp("baseInfoWeight").setText('');
		Ext.getCmp("baseInfoDiag").setText('');
		
		orddetailgridds.removeAll();
	}
	
	
  var task_RealTimeMointor = {
		run : FindWardList  ,//执行任务时执行的函数
		interval : 60000 
		//任务间隔，毫秒为单位，这里是10秒
	}

	
   
  function StartAutoLoadTree()
  {
	
	 Ext.TaskMgr.start(task_RealTimeMointor);

	 
  }
 function StopAutoLoadTree()
 {
         Ext.TaskMgr.stop(task_RealTimeMointor);
         
  }
  
  
  function FindList()
  {
  	wardlistst.removeAll() ;
    patlistst.removeAll() ;
  	InitPatInfo();
  	var p = Ext.getCmp("ListTab").getActiveTab();
  	 if (p.id=="wardlisttab"){
  	 	FindWardList()
  	 }
  	 if (p.id=="wardpatlisttab"){
  	 	FindWardPatList();
  	 }
  	 
  }
   //获到病区列表
  function FindWardList()
  {
  	
  	 InputStr=GetListInput();
	 waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." }); 
     waitMask.show();
                
	 wardlistst.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetWardListData&input='+InputStr  });		
					wardlistst.load({
					params:{start:0, limit:wardlistgridPagingToolbar.pageSize},
					callback: function(r, options, success){
	 
			        waitMask.hide();
			        if (success==false){
			                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
	     		                     }
	      }
	     
	
	   });
  }
    //获到病区病人列表
   function FindWardPatList()
   {

     InputStr=GetListInput();
	 waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." }); 
     waitMask.show();
                
	 patlistst.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetAdmTreeData&input='+InputStr  });		
					patlistst.load({
					params:{start:0, limit:patlistgridPagingToolbar.pageSize},
					callback: function(r, options, success){
	 
			        waitMask.hide();
			        if (success==false){
			                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
	     		                     }
	      }
	     
	
	   });
   	
	 

   }
   
   //显示加载
  	function StartLoading()
	{
		 //waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." }); 
         //waitMask.show(); 
	}

	function EndLoading()
	{
         //waitMask.hide(); 
	}
	
	
	
	///初始化默认科室
  
  function setDefaultLoc()
   { 

     var locdr=session['LOGON.CTLOCID'].toString();
     PhaLocSelecter.setValue(locdr) ;
    
   }  
	
   //返回左边列表选择条件
  function GetListInput()
  {
  	    sdate=Ext.getCmp("startdt").getRawValue().toString();
        edate=Ext.getCmp("enddt").getRawValue().toString();
        phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
        warddr=Ext.getCmp('WardDescCombox').getValue();
        wardid=PatInfo.wardid;
        if (wardid!=0) {warddr=wardid;}
        onlyout=Ext.getCmp('OnlyOutChk').getValue();
        onlyadt=Ext.getCmp('OnlyAdtChk').getValue();
         
  	    var listinputstr=sdate+"^"+edate+"^"+phlocdr+"^"+warddr+"^"+onlyout+"^"+onlyadt ;
  	    return listinputstr
  }
	
  //清理更多条件
  function ClearMore()
  {
  	Ext.getCmp('WardDescCombox').setValue('');
  }
  
  //树的单击事件
  function treeClick(node, e) {
	

                var adm=node.attributes.id;
                ClearWindow();
                GetInPatInfo(adm);
                PatInfo.adm=adm;
		        HrefRefresh(); 


   }
   
    //获取该登记号下的所有就诊记录
   function GetAdmDs(RegNo)
   {
   	            patinfost.removeAll();
   	            var patLen = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetPatRegNoLen");
   	            
   	            var plen=RegNo.length;
			 	if (plen>patLen){
			 		Ext.Msg.show({title:'错误',msg:'输入登记号错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			 		return;
			 	}
			 	
				for (i=1;i<=patLen-plen;i++)
			  	{
				 	 RegNo="0"+RegNo;  
			    }
   	  
   	            waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." }); 
                waitMask.show();
                
				patinfost.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetAdmDs&RegNo='+RegNo  });		
				patinfost.load({
				callback: function(r, options, success){
 
		         waitMask.hide();
		         if (success==false){
		                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		         
		
		});
   	
   }
  
  //////*****************************大通合理用药接口内容//////// 
   
     ///大通药典提示
  function DaTongYDTSBtnClick()
  {		  
       	 var rows = Ext.getCmp("orddetailtbl").getSelectionModel().getSelections(); 
		 var totalnum=rows.length;
		 
		 if (totalnum==0){
		    return;
		 }
		  var currow = orddetailgrid.getSelectionModel().getSelected();
		  var orditm =currow.get("orditem") ;
		  
		  dtywzxUI(3,0,"");
		  var myPrescXML=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDTYDTS", orditm);

		  myrtn=dtywzxUI(12,0,myPrescXML);
  
  }
   
   //列单击事件
  function OrddetailGridCellClick(grid, rowIndex, columnIndex, e)
  {
        if (columnIndex==1){

					  	  var newmoeori="";
					      var record = orddetailgrid.getStore().getAt(rowIndex);
					  	  var moeori =record.data.moeori ;
					      
						  var rsm = orddetailgrid.getSelectionModel();
					      var view = orddetailgrid.getView();
					      var store = orddetailgrid.getStore();
					      
					      if (rsm.isSelected(rowIndex))
					      {
					      	   for (i=1;i<=view.getRows().length-1;i++)
					      	   {
							       if(rsm.isSelected(i)){       
							          //rsm.deselectRow(i)  
							       }
							       else
							       { 
							         var record = orddetailgrid.getStore().getAt(i);
							  	     var newmoeori =record.data.moeori ;
							  	     
							  	     if (newmoeori==moeori){
							  	     	 rsm.selectRow(i,true);
							  	     }
							  	     else
							  	     {
							  	     	if (i>rowIndex) break;
							  	     }
							       	
							
							       }
					       
					           }
					
					      }else{
					      	 
					      	   for (i=1;i<=view.getRows().length-1;i++)
					      	   {
							       if(rsm.isSelected(i)){       
							         var record = orddetailgrid.getStore().getAt(i);
							  	     var newmoeori =record.data.moeori ;
							  	     
							  	     if (newmoeori==moeori){
							  	     	 rsm.deselectRow(i);
							  	     }
							  	     else
							  	     {
							  	     	if (i>rowIndex) break;
							  	     }
							       }
							       else
							       { 
					
							       }
					       
					           }
					      	
					      }
			
		   }

     if (columnIndex==2){
     	          //大通合理用药
     	          /*
		  var record = orddetailgrid.getStore().getAt(rowIndex); 
		  var mainflag =record.data.mainflag ;
		  //if (mainflag!=1)return ; //非主医嘱退出
		  dtywzxUI(3,0,"");
		  var totalnum =orddetailgrid.getStore().getCount() ;
		  var oldadm="";
		  var ordstr="";
		  for(var i=rowIndex;i<totalnum;i++){
		  	    var record = orddetailgrid.getStore().getAt(i); 
		        var adm =record.data.adm ;
		        var orditem =record.data.orditem ;
		        if (oldadm=="") {
		           ordstr=orditem;
		           oldadm=adm ;
		        }else{
		        	if (oldadm==adm){
		        		if (ordstr==""){
		                	ordstr=orditem ;
		                }else{
		                	ordstr=ordstr+"^"+orditem ;
		                }
		        	}else{
		        		continue;
		        	}
		        }
		       
		        
		        
		  }
		  
		  var myPrescXML=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongPresInfo", ordstr);
		  myrtn=dtywzxUI(28676,1,myPrescXML);
		  */
        }


  }

  //大通处方分析
  function DaTongPrescAnalyse()
  {	

	 var totalnum =orddetailgrid.getStore().getCount() ;
	 if (totalnum==0){
	    return;
	 }
      
	 var lightrow="";
	 var oldadm="";
	 var ordstr="";
        var admnum=0;
	 for(var i=0;i<totalnum;i++){
		      
	 	        dtywzxUI(3,0,"");
		        var record = orddetailgrid.getStore().getAt(i); 
		        var adm =record.data.adm ;
                     var orditem =record.data.orditem ;
                     
		        
		        if (adm!=oldadm){
		             
                            admnum=admnum+1 ;

		        	if (oldadm!=""){
		        	
		        		      
		        		    	var myPrescXML=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongPresInfo", ordstr);
                                           
						        myrtn=dtywzxUI(28676,1,myPrescXML);
						        if (myrtn==0) {var imgname="greenlight.gif";}
								if (myrtn==1) {var imgname="yellowlight.gif";}
							    if (myrtn==2) {var imgname="blacklight.gif";}
							    
				                var str="<img id='DrugUseImg"+i +"'"+" src='../scripts/dhcpha/img/"+imgname+"'>";
							    orddetailgrid.getView().getCell(lightrow,2).innerHTML=str 
							    
		        	}
		             
                           	lightrow=i;
		        	oldadm=adm;
                           ordstr=orditem ;
				    
		            
                            
                    
		        }else{
		        	    if (ordstr==""){
		                	ordstr=orditem ;
		                }else{
		                	ordstr=ordstr+"^"+orditem ;
		                }
		        }

                       
      
		         
	 }
        if (admnum>0){
                              
                	      
		        		    	var myPrescXML=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongPresInfo", ordstr);
                                           
						        myrtn=dtywzxUI(28676,1,myPrescXML);
						        if (myrtn==0) {var imgname="greenlight.gif";}
								if (myrtn==1) {var imgname="yellowlight.gif";}
							    if (myrtn==2) {var imgname="blacklight.gif";}
							    
				                var str="<img id='DrugUseImg"+i +"'"+" src='../scripts/dhcpha/img/"+imgname+"'>";
							    orddetailgrid.getView().getCell(lightrow,2).innerHTML=str 
         }
	 
  	
  }
	    //初始化 
	function StartDaTongDll()
	{
		
		dtywzxUI(0,0,"");
	}
	
	function dtywzxUI(nCode,lParam,sXML){
	   var result;
	   result = CaesarComponent.dtywzxUI(nCode, lParam,sXML);
	   return result;
	}
	//////*****************************////////////////////////////////
	
	
	
	
	
	
	 
	 
	///////////////美康合理用药接口内容////////
	function showMKHMTL(value, cellmeta, record, rowIndex, colIndex, store) {
		var oeori=record.get("orditem")
		var oeori=oeori.replace("||",".")
		var str="<label id=\""+rowIndex+"\" name=\""+rowIndex+ "\"><div id=\"McRecipeCheckLight_" + oeori + "\" name=\"McRecipeCheckLight\" class=\"DdimRemark_null\"></div>";  	
    	return str;
	}
	    //美康处方分析
	function MKPrescAnalyse()
	{	
	  	 var totalnum =orddetailgrid.getStore().getCount() ;
		 if (totalnum==0){
		    return;
		 }
		 MKXHZY(2);
	 }
	//美康药品信息显示
	function GetDrugQueryInfo()
	{
  
      //alert("GetDrugQueryInfo");
	   var record = orddetailgrid.getStore().getAt(UpRow);   
       var oeori =record.data.orditem ;
       var medinfo=tkMakeServerCall("web.DHCSTPIVAMKInterface", "GetMedicineInfo", oeori);
       //alert("medinfo="+medinfo);
	   var medarr=medinfo.split("^");
	   var OrderARCIMCode=medarr[0];
	   var OrderName=medarr[1];
	   var OrderDoseUOM=medarr[2];
	   var OrderInstrDesc=medarr[3];
	   var OrderInstrCode=medarr[4];
       //alert("OrderInstrCode="+OrderInstrCode);
	   var dqi = new Params_GetDrugQueryInfo_In();
	   
	   dqi.DrugType = "USER_Drug" ;
	   dqi.RouteType = "USER" ;
	   dqi.DrugCode = OrderARCIMCode; 	//药品编码
	   dqi.DrugName = OrderName;		//药品名称
	   dqi.DoseUnit = OrderDoseUOM;		//给药单位
	   dqi.RouteDesc = OrderInstrDesc;	//给药途径名称
	   dqi.RouteID  = OrderInstrCode;	//给药途径编号和给药途径名称一样
   
	   McDrugQueryInfoModel = dqi;
	   
	}
	
		///美康相互作用
	function MKXHZY(Flag){
		
		
		var totalnum =orddetailgrid.getStore().getCount() ;
		 if (totalnum==0){
		    return;
		}
		var oldadm="";
		var ordstr="";
		var num=0;
		for(var i=0;i<totalnum;i++){

	        var record = orddetailgrid.getStore().getAt(i); 
	        var adm =record.data.adm ;
	     
            var orditem =record.data.orditem ;
            if (oldadm=="") oldadm=adm ;
            if (oldadm==adm){
	            if (ordstr==""){
		            ordstr=orditem
	            }else
	            {
		            ordstr=ordstr+"^"+orditem ;
	            }
            }
            else
            {
	            alert("ordstr="+ordstr);
	            var retstr=tkMakeServerCall("web.DHCSTPIVAMKInterface", "GetPrescInfo", ordstr);
	            alert("retstr="+retstr);
	            oldadm=adm ;
	            ordstr=orditem;
	            MK(Flag,retstr)
            }
          
            
		}
		
		
		var retstr=tkMakeServerCall("web.DHCSTPIVAMKInterface", "GetPrescInfo", ordstr);
                alert("retstr="+retstr);
		MK(Flag,retstr)
		
		
		
	}
	
    function MK(Flag,retstr)
    {
	    
	    var TempArr=retstr.split(String.fromCharCode(2));
	    var PatInfo=TempArr[0];
	    var MedCondInfo=TempArr[1];
	    var AllergenInfo=TempArr[2];
	    var OrderInfo=TempArr[3];
		var PatArr=PatInfo.split("^");
		var ppi = new Params_Patient_In();
		ppi.PatID = PatArr[0];			// 病人编码
		ppi.PatName = PatArr[1];		// 病人姓名
		ppi.Sex = PatArr[2];				// 性别
		ppi.Birth = PatArr[3];			// 出生年月
		ppi.UseTime = PatArr[4];		// 使用时间
		ppi.Height = PatArr[5];			// 身高
		ppi.Weight = PatArr[6];			// 体重
		ppi.VisitID = PatArr[7];		// 住院次数
		ppi.Department = PatArr[8];	    // 住院科室
		ppi.Doctor = PatArr[9];			// 医生
		ppi.OutTime = PatArr[10];		// 出院时间
		McPatientModel = ppi;

	    var arrayObj = new Array();
		var pri;
  
	    var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
	    McRecipeCheckLastLightStateArr = new Array();
		for(var i=0; i<OrderInfoArr.length ;i++)
		{   
		    var OrderArr=OrderInfoArr[i].split("^");
		    var oeori=OrderArr[14].replace("||",".")
	        pri = new Params_Recipe_In();
				
			//传给core的?并且由core返回变灯的唯一编号?构造的灯div的id也应该和这个相关联
	        pri.Index = oeori;
	        pri.DrugCode = OrderArr[1]; 		//药品唯一码
	        pri.DrugName = OrderArr[2]; 		//药品名称
	        pri.DrugType = "USER_Drug"; 
	        pri.SingleDose = OrderArr[3]; 	//每次用量
	        pri.DoseUnit = OrderArr[4]; 		//给药单位
	        pri.Frequency = OrderArr[5]; 	//用药频次(次/天)
	        pri.StartDate =OrderArr[6]; 	//开始时间?格式yyyy-mm-dd
	        pri.EndDate = OrderArr[7]; 		//结束时间?格式?yyyy-mm-dd
	        pri.RouteDesc =OrderArr[8]; 	//给药途径名称
	        pri.RouteID =OrderArr[9]; 		//给药途径编号?同给药途径名称
	        pri.RouteType = "USER"; 
	        pri.GroupTag = OrderArr[10]; 		//成组标记
	        pri.IsTemporary =OrderArr[11]; //是否为临时医嘱  1-临时医嘱 0-长期医嘱
	        pri.Doctor =OrderArr[12]; 			//医生姓名

	        arrayObj[arrayObj.length] = pri;
		}
		McRecipeDataList = arrayObj;
    
    
		var arrayObj = new Array();
		var pai;
	
		var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
		for(var i=0; i<AllergenInfoArr.length ;i++)
		{
			var AllergenArr=AllergenInfoArr[i].split("^");
	        pai = new Params_Allergen_In();
	        pai.Index = i; 						//过敏源处方顺序编号?以0开始的唯一索引号?
	        pai.AllergenCode =AllergenArr[0]; 	//过敏源编码
	        pai.AllergenDesc =AllergenArr[1]; 	//过敏源名称
	        pai.AllergenType =AllergenArr[2]; 	//过敏源类型
	        pai.Reaction =AllergenArr[3]; 			//过敏症状

	        arrayObj[arrayObj.length] = pai;
		}
		McAllergenDataList = arrayObj;

		//病生状态类数组
		var arrayObj = new Array();
		var pmi;
 
	    var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));

		for(var i=0; i<MedCondInfoArr.length ;i++)
		{			
			var MedCondArr=MedCondInfoArr[i].split("^");
	        pmi = new Params_MedCond_In();
	        pmi.Index = i; 	//顺序编号?以0开始的唯一索引号?
	        pmi.MedCondCode =MedCondArr[0]; 	//疾病编码
	        pmi.MedCondDesc =MedCondArr[1]; 	//疾病名称
	        pmi.MedCondType =MedCondArr[2]; 	//疾病类型
	        pmi.StartDate =MedCondArr[3]; 		//开始时间
	        pmi.StopDate =MedCondArr[4]; 			//结束时间
	        pmi.VocabTypeCode = MedCondArr[5];	//疾病Vocab类型编码
	        arrayObj[arrayObj.length] = pmi;
		}
		McMedCondDataList = arrayObj;
	
		if (Flag==0) FuncSingleRecipeCheck(0);
		if (Flag==1) FuncRecipeCheck(0,2); //标准审查
		if (Flag==2) FuncRecipeCheck(0,1); //简洁模式审查
		if (Flag==3) FuncRecipeCheck(7,2); //妊娠期审查
		if (Flag==4) FuncRecipeCheck(5,2); //哺乳期审查

	}

     //右键
	function OrddetailMouseUpClick(e)
	{
        var totalnum =orddetailgrid.getStore().getCount() ;
		 if (totalnum==0){
		    return;
		}
		
		var rowIndex = orddetailgrid.getView().findRowIndex(e.getTarget());
		if (rowIndex.toString()=="false") return;
		UpRow=rowIndex;
		//CreatePostHisAllQueryData(1);
		GetDrugQueryInfo();
		OnMouseUpRightMenu(1,-2,"true");
	}
	
	//双击
	function OrddetailGridCellDblClick(grid, rowIndex, columnIndex, e)
	{
	    var totalnum =orddetailgrid.getStore().getCount() ;
		 if (totalnum==0){
		    return;
		}
		
        if (columnIndex==2)
        {
                var record = orddetailgrid.getStore().getAt(rowIndex); 
			    var curradm =record.data.adm ;
				var ordstr="";
				var num=0;
				for(var i=0;i<totalnum;i++){

			        var record = orddetailgrid.getStore().getAt(i); 
			        var adm =record.data.adm ;
			        if ((adm!=curradm)&&(i>rowIndex)) break;
	                if (adm!=curradm) continue;
		            var orditem =record.data.orditem ;
	
			            if (ordstr==""){
				            ordstr=orditem
			            }else
			            {
				            ordstr=ordstr+"^"+orditem ;
			            }
	
          
            
				}
		
				var retstr=tkMakeServerCall("web.DHCSTPIVAMKInterface", "GetPrescInfo", ordstr);
                                alert("retstr="+retstr);
				MK(1,retstr)
	        
        }
	}
	
            //////////////////////////////////////////////////////////
            
            
            
            
            
            
            
            
});