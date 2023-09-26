
var unitsUrl = 'dhcpha.comment.query.save.csp';
var idTmr="";
var comwidth=120;

Ext.onReady(function() {

     Ext.QuickTips.init();// 浮动信息提示
	 Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	 Ext.Ajax.timeout = 900000;

	 var ResultData=[['仅合格','1'],['仅不合格','2'],['仅有结果','4'],['全部','3']];
	 
	 
	 var Resultstore = new Ext.data.SimpleStore({
		fields: ['retdesc', 'retid'],
		data : ResultData
		});

	var ResultCombo = new Ext.form.ComboBox({
		store: Resultstore,
		displayField:'retdesc',
		mode: 'local', 
		width : comwidth,
		id:'ResultCmb',
		emptyText:'',
		valueField : 'retid',
		emptyText:'选择点评结果...',
		fieldLabel: '点评结果'
	});


          ///定义医生科室
	
  var ComBoDocLocDs = new Ext.data.Store({
		        autoLoad: true,

			proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=GetDocLocDs',
			method : 'POST'
		}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'DocLocID'},
['DocLocDesc','DocLocID'])
				
	});


  ComBoDocLocDs.on(
	'beforeload',
	function(ds, o){
	
		ds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetDocLocDs', method:'GET'});
	
	}
  );

  var DocLocSelecter = new Ext.ux.form.LovCombo({
		fieldLabel:'医生科室',
		id:'DocLocSelecter',
		name:'DocLocSelecter',
		store : ComBoDocLocDs,
		width:comwidth,
		listWidth : 250,
		emptyText:'选择医生科室...',
		hideOnSelect : false,
		maxHeight : 300,	
		valueField : 'DocLocID',
		displayField : 'DocLocDesc',
		triggerAction : 'all',
		mode:'local'

				
	});
	
	
 ///定义药品名称
	
	var ComBoIncitmDs = new Ext.data.Store({
		//autoLoad: true,
		proxy : new Ext.data.HttpProxy({
			url : unitsUrl,
//					+ '?action=GetIncitmDs&start=0&limit=50&searchItmValue=',

			method : 'POST'
		}),
		//proxy : '',
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows',
					id : 'rowId'
				}, ['rowId', 'itmcode', 'itmdesc'])

	});
	
	
	
	 var tpl =  new Ext.XTemplate(
	'<table cellpadding=2 cellspacing = 1><tbody>',
	'<tr><th style="font-weight: bold; font-size:15px;">药品名称</th><th style="font-weight: bold; font-size:15px;">编码</th><th style="font-weight: bold; font-size:15px;">ID</th></tr>',
	'<tpl for=".">',
	'<tr class="combo-item">',
	'<td style="width:500; font-size:15px;">{itmdesc}</td>',
	'<td style="width:20%; font-size:15px;">{itmcode}</td>',
	'<td style="width:50; font-size:15px;">{rowId}</td>',
	'</tr>',
	'</tpl>', '</tbody></table>');
	

	var IncitmSelecter = new Ext.form.ComboBox({
				id : 'InciSelecter',
				fieldLabel : '药品名称',
				store : ComBoIncitmDs,
				valueField : 'rowId',
				displayField : 'itmdesc',
				//typeAhead : true,
				pageSize : 50,
				//minChars : 1,
				width:comwidth,
				// heigth : 150,
				autoHeight:true,
				listWidth : 550,
				triggerAction : 'all',
				emptyText : '选择药品名称...',
				//allowBlank : false,
				name : 'IncitmSelecter',
				selectOnFocus : true,
				forceSelection : true,
				tpl: tpl,
    				itemSelector: 'tr.combo-item',
				listeners : {
				
				        
				        specialKey :function(field,e){
				        
                                        if (e.getKey() == Ext.EventObject.ENTER) {
                                               
                                             	ComBoIncitmDs.proxy = new Ext.data.HttpProxy({
										url : unitsUrl
												+ '?action=GetIncitmDs&searchItmValue='
												+ Ext.getCmp('InciSelecter').getRawValue(),
										method : 'POST'
									})
							ComBoIncitmDs.reload({
										params : {
											start : 0,
											limit : IncitmSelecter.pageSize
										}
									});
                                        
                                                     }					
				                }
				               
			         }

	});
	
	
  var StDateField=new Ext.form.DateField ({
               
                xtype: 'datefield',
                format:'j/m/Y' ,
                fieldLabel: '开始日期',
                name: 'startdt',
                id: 'startdt',
                invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
                width : comwidth,
                value:new Date
            })	
            
            
            
  var EndDateField=new Ext.form.DateField ({
                format:'j/m/Y' ,
                fieldLabel: '截止日期',
	        name: 'enddt',
	        id: 'enddt',
	        width : comwidth,
	        value:new Date
            })
            
   var FindButton = new Ext.Button({
             width : 65,
             id:"FindButton",
             text: '统计',
             icon:"../scripts/dhcpha/img/find.gif",
             listeners:{   
                          "click":function(){   
                             
                              FindCNTSData("");
                              
                              }   
                       } 
             
             }) 
             
    var ExportButton = new Ext.Button({
             width : 65,
             id:"ExportButton",
             text: '导出Excel',
             icon:"../scripts/dhcpha/img/save.gif",
             listeners:{   
                          "click":function(){   
                             
                              ExportNTSData();
                              
                              }   
                       } 
             
             })   
        
        
       var FindNoButton = new Ext.Button({
             width : 65,
             id:"FindNoButton",
             text: '查点评单',
             icon:"../scripts/dhcpha/img/multiref.gif",       
             listeners:{   
                          "click":function(){   
                             
                            FindCommentFun();
                              }   
                       } 
             
             
             
             })
                         
            
       var ClearButton = new Ext.Button({
             width : 65,
             id:"ClearButton",
             text: '清屏',
             listeners:{
                          "click":function(){   
                             
                              ClearWindow();
                              
                              }   
             }
             
             })
             
             
             
             
             
             
             
              var QueryForm = new Ext.FormPanel({
                                labelWidth : 80,
				region : 'north',
				title:'点评单统计查询',
				frame : true,
				height:140,
				tbar:[FindButton,'-',FindNoButton,'-',ExportButton],
				items : [{
							layout : "column",
							items : [{
							                        labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [   StDateField  ]
									}, {
									        labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [   EndDateField  ]
									    
										
								        },{
								        
								                labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [   DocLocSelecter  ]
								        }  
								        
								        
								        
								        
				                                 ]
								   
								   
								   
								   
					},{
					
					
							layout : "column",
							items : [{
							                        labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [  ResultCombo   ]
									}, {
									        labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [  IncitmSelecter  ]
									    
										
								        },{
								                labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [   ]	    
										
								        }
								        	
								        
								   ]
					
					    }
					

					
					
					
					]

			});				
			
 



			
			       
    
   ////明细table 
 var nm = new Ext.grid.RowNumberer();   
 var commentitmgridcm = new Ext.grid.ColumnModel([nm,

       
        {header:'点评单',dataIndex:'pcntsno',width:100},
        {header:'处方号',dataIndex:'prescno',width:100},
        {header:'登记号',dataIndex:'patno',width:80},
        {header:'姓名',dataIndex:'patname',width:80},
        {header:'性别',dataIndex:'patsex',width:60},
        {header:'年龄',dataIndex:'patage',width:60},
        {header:'费别',dataIndex:'billtype',width:80},
        {header:'诊断',dataIndex:'diag',width:200},
        {header:'医生科室代码',dataIndex:'orddeptcode',width:80},
        {header:'医生科室',dataIndex:'orddept',width:80},
        {header:'医生工号',dataIndex:'doctorcode',width:80},
        {header:'医生',dataIndex:'doctor',width:80},
        {header:'配药药师',dataIndex:'pyuser',width:80},
        {header:'发药药师',dataIndex:'fyuser',width:80},
        {header:'药品名称',dataIndex:'incidesc',width:180}, 
        {header:'数量',dataIndex:'qty',width:80},
        {header:'单价',dataIndex:'price',width:80},
        {header:'金额',dataIndex:'amt',width:80},
        {header:'处方总金额',dataIndex:'prescamt',width:80},
        {header:'抗菌药总金额',dataIndex:'sumantamt',width:80},
        {header:'抗菌药总金额百分比',dataIndex:'antamtcent',width:80},
        {header:'基本药物总金额',dataIndex:'sumbasamt',width:80},
        {header:'基本药物总金额百分比',dataIndex:'basamtcent',width:80},
        {header:'单位',dataIndex:'uomdesc',width:80},
        {header:'剂量',dataIndex:'dosage',width:80},
        {header:'频次',dataIndex:'freq',width:80},
        {header:'用法',dataIndex:'instru',width:80},
        {header:'疗程',dataIndex:'duration',width:80},
        {header:'备注',dataIndex:'remark',width:80},
        {header:'colorflag',dataIndex:'colorflag',width:0,hidden:true},
        {header:'点评药师',dataIndex:'username',width:80},
        {header:'结果',dataIndex:'curret',width:60},
        {header:'原因',dataIndex:'reason',width:300},
        {header:'药师建议',dataIndex:'phadvice',width:100},
        {header:'药师备注',dataIndex:'phnote',width:300},
        {header:'pid',dataIndex:'pid',width:0,hidden:true}
 
       
            
    
    ]);
 
 
    var commentitmgridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'pcntsno',
            'prescno',
	    'patno',
	    'patname',
	    'patsex',
	    'patage',
	    'billtype',
	    'diag',
	    'orddeptcode',
	    'orddept',
	    'doctorcode',
	    'doctor',
	    'curret',
	    'incidesc',
	    'colorflag',
	    'reason',
	    'phadvice',
	    'phnote',
	    'pid',
	    'qty',
	    'price',
	    'amt',
	    'prescamt',
	    'sumantamt',
	    'antamtcent',
	    'sumbasamt',
	    'basamtcent',
	    'uomdesc',
	    'dosage',
	    'freq',
	    'instru',
	    'duration',
	    'remark',
	    'pyuser',
	    'fyuser',
	    'username'
	    
	    
		]),
		
		

    remoteSort: true
});


 var commentitmgridPagingToolbar = new Ext.PagingToolbar({	
			store:commentitmgridds,
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

 
 var commentitmgrid = new Ext.grid.GridPanel({
        
        id:'commentgriditmtbl',
        //stripeRows: true,
        region:'center',
        width:150,
        //height:290,
        autoScroll:true,
	title:"",
        enableHdMenu : false,
        ds: commentitmgridds,
        cm: commentitmgridcm,
        enableColumnMove : false,
        view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    // render rows as they come into viewable area.
		    scrollDelay: false,
		       
		   getRowClass: function(record, index, rowParams, store) {  
		   
		   
			   if (record.data.colorflag > 0) {
			   
			   return 'x-grid-record-green'; 
			   
			   }
		   
		   }
		    
		    
	    }),
	    
        bbar: commentitmgridPagingToolbar,
        trackMouseOver:'true'
        

        
    });  
    
   
   
   ////按原因汇总
   
   
 function showUrl(data, metadata, record, rowIndex, columnIndex, store)  
 { 
  	var doclocdr = store.getAt(rowIndex).get('locrowid'); //科室
  
	sdate=Ext.getCmp("startdt").getRawValue();       
        edate=Ext.getCmp("enddt").getRawValue();
        inci=Ext.getCmp("InciSelecter").getValue(); //药品
        result=Ext.getCmp("ResultCmb").getValue(); //药品
                
        QueryStr=sdate+"^"+edate+"^"+doclocdr+"^"+inci+"^"+result;
               
       // var lnk="dhcpha.comment.querybydocloc.csp?QueryStr="+QueryStr ;
        var str2="<a href='http://www.baidu.com'>111</a>"

var str="<a   href ='javascript:alert(111)'>打开一个新窗口</a >"

        //return "<a href="+lnk+" target='_blank'  >"+data+"</a>";
        return str;
        

      
  
  }  

   
    
 var GroupRow1 = [
                                           {header:'科室',align:'center',colspan:2},
   					   {header:'不规范处方',align:'center',colspan:4},
   					   {header:'用药不宜处方',align:'center',colspan:4},
   					   {header:'超常处方',align:'center',colspan:4},
   					   {header:'不合理',align:'center',colspan:2},
   					   {header:'总处方',align:'center',colspan:2}
   			] 
   			
   var GroupRow3 = [
                                           {header:'',align:'center',colspan:7},
   					   {header:'A',align:'center',colspan:1},
   					   {header:'B',align:'center',colspan:1},
   					   {header:'',align:'center',colspan:2}
   			] 
   			
    var GroupRow2 = [
        //{
        //header:'科室',
        //dataIndex:'locdesc',
        //renderer:showUrl},
        {header:'科室',dataIndex:'locdesc',width:150},
        {header:'科室ID',dataIndex:'locrowid',width:0,hidden:true},
        {header:'问题数量',dataIndex:'reason1',width:75},
        {header:'占总问题比',dataIndex:'centprescn1',width:75},
        {header:'处方数量',dataIndex:'locrepnum1',width:75},
        {header:'占总数量比',dataIndex:'locrepcent1',width:75},
        {header:'问题数量',dataIndex:'reason2',width:75},
        {header:'占总问题比',dataIndex:'centprescn2',width:75},
        {header:'处方数量',dataIndex:'locrepnum2',width:75},
        {header:'占总数量比',dataIndex:'locrepcent2',width:75},
        {header:'问题数量',dataIndex:'reason3',width:75},
        {header:'占总问题比',dataIndex:'centprescn3',width:75},
        {header:'处方数量',dataIndex:'locrepnum3',width:75},
        {header:'占总数量比',dataIndex:'locrepcent3',width:75},
        {header:'问题总数量',dataIndex:'locreanum',width:75},
        {header:'处方总数量',dataIndex:'locbedprescnum',width:75},
        {header:'全院各科处方数',dataIndex:'locallprescnum',width:95},  
        {header:'点全院处方比',dataIndex:'loccentprescnum',width:85},  
 		{header:'pid',dataIndex:'pid',hidden:true}  

   			]   
    var group = new Ext.ux.grid.ColumnHeaderGroup({
        rows: [GroupRow1]
    });
    

 
    var reasongridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'locdesc',
            'locrowid',
            'reason1',
	    'centprescn1',
	    'locrepnum1',
	    'locrepcent1',
	    'reason2',
	    'centprescn2',
	    'locrepnum2',
	    'locrepcent2',
	    'reason3',
	    'centprescn3',
	    'locrepnum3',
	    'locrepcent3',
	    'locreanum',
	    'locbedprescnum',
	    'locallprescnum',
	    'loccentprescnum',
	    'pid'
	    
		]),
		
		

    remoteSort: true
});



 
 var reasongrid = new Ext.grid.GridPanel({
     
        //width: 1000,
        //height: 400,
        stripeRows: true,
        enableColumnMove : false,
        enableHdMenu : false,
        store: reasongridds,
        columns: GroupRow2,
        view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    // render rows as they come into viewable area.
		    scrollDelay: false
			   		    
	    }),
	    
        trackMouseOver:'true',

        plugins: group
        
    });

   
   
   ////
   
   
   
      ////按处方汇总 
 
 var prescgridcm = new Ext.grid.ColumnModel([

       
        {header:'序号',dataIndex:'count',width:60},
        {header:'处方号',dataIndex:'prescno',width:100},
        {header:'登记号',dataIndex:'patno',width:80},
        {header:'姓名',dataIndex:'patname',width:80},
        {header:'性别',dataIndex:'patsex',width:35},
        {header:'处方日期',dataIndex:'orddate',width:100},
        {header:'年龄',dataIndex:'patage',width:35},
        {header:'诊断',dataIndex:'diag',width:150},
        {header:'药品品种',dataIndex:'itmnum',width:80},
        {header:'抗菌药',dataIndex:'kjnum',width:80},
        {header:'注射剂',dataIndex:'zsnum',width:80},
        {header:'国家基本药物品种数',dataIndex:'bnum',width:80},
        {header:'药品通用名数',dataIndex:'gernum',width:80},
        {header:'处方金额',dataIndex:'amt',width:100}, 
        {header:'处方医师',dataIndex:'doctor',width:80},
        {header:'配药药师',dataIndex:'pyuser',width:80},   
        {header:'发药药师',dataIndex:'fyuser',width:80}, 
        {header:'是否合理',dataIndex:'curret',width:60},
        {header:'存在问题(代码)',dataIndex:'reason',width:80},
        {header:'pid',dataIndex:'pid',width:80,hidden:true}

        
    
    ]);
 
 
    var prescgridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'count',
            'prescno',
	    'patno',
	    'patname',
	    'patsex',
	    'patage',
	    'diag',
	    'curret',
	    'doctor',
	    'kjnum',
	    'zsnum',
	    'bnum',
	    'gernum',
	    'amt',
	    'pyuser',
	    'fyuser',
	    'result',
	    'reason',
	    'itmnum',
	    'orddate',
	    'pid'
	    
		]),
		
		

    remoteSort: true
});




	

 var prescgridPagingToolbar = new Ext.PagingToolbar({	
			store:prescgridds,
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

 
 var prescgrid = new Ext.grid.GridPanel({
        
        id:'presctbl',
        stripeRows: true,
        region:'center',
        width:150,
        //height:290,
        autoScroll:true,
	title:"",
        enableHdMenu : false,
        ds: prescgridds,
        cm: prescgridcm,
        enableColumnMove : false,
        view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    // render rows as they come into viewable area.
		    scrollDelay: false
		    
		    
	    }),
	    
        bbar: prescgridPagingToolbar,
        trackMouseOver:'true'
        

        
    });  
    
    
     
    
    ///Tabs定义
    
    var QueryTabs = new Ext.TabPanel({
	    region: 'center',
	    id:'TblTabPanel',
	    //margins:'3 3 3 0', 
	    activeTab: 0,
	    //defaults:{autoScroll:true},
	    //deferredRender:false,
	     height:260,
	     autoHight:'true',
	    items:[{
	        title: '按处方明细',
	        id:'1',
	        closable:false,
	        layout:'fit',	    
	        //listeners: {activate: Clearpatinfo},
	        items: commentitmgrid
	
	    },{
	        title: '按处方汇总',
	        id:'3',
	        closable:false,
	        layout:'fit',
	        items:[prescgrid]
	    },{
	        title: '按原因汇总',
	        id:'2',
	        closable:false,
	        layout:'fit',
	        items:[reasongrid]
	    }
	    
	    
	    ],
	    
	      listeners:{ 
                              beforetabchange:function(t,  newTab,  currentTab){ 
                                    
                                          if (currentTab){
                                             
                                          }
                                    }
                                
                      } 
	    
	    
	    
	    
	});
	
	
	/*
	
	,
	    {
	        //title: '按抗菌药明细',
	        //id:'4',
	        //closable:false,
	        //layout:'fit',
	        //html: '<iframe id="adult" width=100% height=100% src=dhcpha.comment.querybyadult.csp></iframe>',
		//src: 'dhcpha.comment.querybyadult.csp'
	    }
	
	*/
	
	
    ///框架定义
    

      var port = new Ext.Viewport({

				layout : 'border',

				items : [QueryForm,QueryTabs]

			});

      
      
      

    
    


///----------------Events----------------



        //右键菜单 
	commentitmgrid.addListener('rowcontextmenu', rightClickFn);
	var rightClick = new Ext.menu.Menu({ 
	    id:'rightClickCont', 
	    items: [ 
	        { 
	            id: 'ExportXls', 
	            handler: ExportNTSData, 
	            text: '导出Excel' 
	        }
	    ] 
	}); 

        
        
        prescgrid.addListener('rowcontextmenu', rightClickFn);
	var rightClick = new Ext.menu.Menu({ 
	    id:'rightClickCont', 
	    items: [ 
	        { 
	            id: 'ExportXls', 
	            handler: ExportNTSData, 
	            text: '导出Excel' 
	        }
	    ] 
	}); 
        
        
        reasongrid.addListener('rowcontextmenu', rightClickFn);
	var rightClick = new Ext.menu.Menu({ 
	    id:'rightClickCont', 
	    items: [ 
	        { 
	            id: 'ExportXls', 
	            handler: ExportNTSData, 
	            text: '导出Excel' 
	        }
	    ] 
	}); 
	
	
		
	function rightClickFn(grid,rowindex,e){ 
	    e.preventDefault(); 
	    rightClick.showAt(e.getXY()); 
        }
        
        
        
        
        


FindCNTSData= function(str)
{

       			KillItm();
                KillTotal();
                KillReaTotal();
                ClearWindow();
                 
                sdate=Ext.getCmp("startdt").getRawValue();       
                edate=Ext.getCmp("enddt").getRawValue();
                doclocdr=Ext.getCmp("DocLocSelecter").getValue();  //科室
                inci=Ext.getCmp("InciSelecter").getValue(); //药品
                result=Ext.getCmp("ResultCmb").getValue(); //药品
                comno="";  //单号串
                retflag="" ;有无结果
                if (str!=""){
                   strarr=str.split("^");
                   var sdate=strarr[0];
                   var edate=strarr[1];
                   var comno=strarr[2];
                   var retflag=strarr[3];
                   
                   var tmparr=sdate.split("/")
                   var sdt=tmparr[2]+"/"+tmparr[1]+"/"+tmparr[0];
                   var tmparr=edate.split("/")
                   var edt=tmparr[2]+"/"+tmparr[1]+"/"+tmparr[0];
                   
                   var dt = new Date(sdt);
                   Ext.getCmp("startdt").setValue(dt);
                   
                   var dt = new Date(edt);
                   Ext.getCmp("enddt").setValue(dt);
                }
                
                QueryStr=sdate+"^"+edate+"^"+doclocdr+"^"+inci+"^"+result+"^"+comno;
                
                var p = Ext.getCmp("TblTabPanel").getActiveTab();
                
                
                
                 ///点评明细
                 
                if (p.id=="1"){
                                
                                waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." ,removeMask: true}); 
	                        waitMask.show();               
                	
                		commentitmgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindCNTSData&QueryStr='+QueryStr});
		
				commentitmgridds.load({
								
				params:{start:0, limit:commentitmgridPagingToolbar.pageSize}, 
				
				callback: function(r, options, success){
		 
				         waitMask.hide() ;
				         if (success==false){
				                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				                     }
				          }
				
				});
				
                }
                
                ///原因汇总
                
               if (p.id=="2"){
                	

                                waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." ,removeMask: true}); 
	                        waitMask.show(); 
                		reasongridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindCNTSDataByRea&QueryStr='+QueryStr});
		
				reasongridds.load({
							
				callback: function(r, options, success){
		 
				         waitMask.hide() ;
				         if (success==false){
				                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				                     }
				          }
				
				});
				
                }
                
                
                
                ///处方汇总
                
               if (p.id=="3"){
               
                                waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." ,removeMask: true}); 
	                        waitMask.show(); 
                		prescgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindCNTSDataByPresc&QueryStr='+QueryStr});
		
				prescgridds.load({
					
				params:{start:0, limit:prescgridPagingToolbar.pageSize}, 
				
				callback: function(r, options, success){
		 
				         waitMask.hide() ;
				         if (success==false){
				                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				                     }
				          }
				
				});
				
                }
                
                if (p.id=="4"){
                
                          
			var p = Ext.getCmp("TblTabPanel").getActiveTab();	
			var iframe = p.el.dom.getElementsByTagName("iframe")[0];
                        iframe.src='dhcpha.comment.querybyadult.csp?QueryStr='+QueryStr;
                
                }

		
		


}


function ClearWindow()
{
   commentitmgridds.removeAll();
   reasongridds.removeAll();
   prescgridds.removeAll();
}
 
    
    

    
reasongrid.on('rowdblclick',function(grid,rowIndex,e){


                var selectedRow = reasongridds.data.items[rowIndex];
	        	var doclocdr = selectedRow.data["locrowid"]; //科室
	        	sdate=Ext.getCmp("startdt").getRawValue();       
                edate=Ext.getCmp("enddt").getRawValue();
                inci=Ext.getCmp("InciSelecter").getValue(); //药品
                result=Ext.getCmp("ResultCmb").getValue(); //药品
        
                QueryStr=sdate+"^"+edate+"^"+doclocdr+"^"+inci+"^"+result
        
	        
                var lnk="dhcpha.comment.querybydocloc.csp?QueryStr="+QueryStr ;
				window.open(lnk,"_blank","height=600,width=1000,menubar=no,status=yes,toolbar=no,resizable=yes") ;

		
		
 });   


 //打开导出窗体
function OpenExpDetailWin(pid)
{
		//var excelUrl = 'dhccpmrunqianreport.csp?reportName=DHCSTCNTSDetailExp.raq&pid='+pid;
		//var NewWin = open(excelUrl, "导出Excel", "top=20,left=20,width=930,height=660,scrollbars=1,resizable=yes");
		
		var expwin=new Ext.Window({
			title: '导出excel',
			width: Ext.getBody().getViewSize().width,
			height: Ext.getBody().getViewSize().height,
			html: '<iframe id="DHCSTCNTSDetailExp" src="dhccpmrunqianreport.csp?reportName=DHCSTCNTSDetailExp.raq&pid=' + pid + '" frameborder="0" width="100%" height="100%"></iframe>',
			layout: 'fit',
			plain: true,
			modal: true
			}).show();

} 



function OpenExpTotalWin(pid)
{
		//var excelUrl = 'dhccpmrunqianreport.csp?reportName=DHCSTCNTSTotalExp.raq&pid='+pid;
		//var NewWin = open(excelUrl, "导出Excel", "top=20,left=20,width=930,height=660,scrollbars=1,resizable=yes");
	
			var expwin=new Ext.Window({
			title: '导出excel',
			width: Ext.getBody().getViewSize().width,
			height: Ext.getBody().getViewSize().height,
			html: '<iframe id="DHCSTCNTSDetailExp" src="dhccpmrunqianreport.csp?reportName=DHCSTCNTSTotalExp.raq&pid=' + pid + '" frameborder="0" width="100%" height="100%"></iframe>',
			layout: 'fit',
			plain: true,
			modal: true
			}).show();
	
}

function OpenExpReaTotalWin(pid)
{
		//var excelUrl = 'dhccpmrunqianreport.csp?reportName=DHCSTCNTSReaTotalExp.raq&pid='+pid;
		//var NewWin = open(excelUrl, "导出Excel", "top=20,left=20,width=930,height=660,scrollbars=1,resizable=yes");
	
			var expwin=new Ext.Window({
			title: '导出excel',
			width: Ext.getBody().getViewSize().width,
			height: Ext.getBody().getViewSize().height,
			html: '<iframe id="DHCSTCNTSDetailExp" src="dhccpmrunqianreport.csp?reportName=DHCSTCNTSReaTotalExp.raq&pid=' + pid + '" frameborder="0" width="100%" height="100%"></iframe>',
			layout: 'fit',
			plain: true,
			modal: true
			}).show();
	
}




//导出数据
function ExportNTSData()
{

			var p = Ext.getCmp("TblTabPanel").getActiveTab();
                 
            if (p.id=="1"){
                    var rows=commentitmgrid.getStore().getCount() ; 
				    if (rows== 0) { return; }
            	    var pid=commentitmgridds.getAt(0).get("pid") ;
                    OpenExpDetailWin(pid)
                }
             
              
            if (p.id=="3"){
                    var rows=prescgrid.getStore().getCount() ; 
				    if (rows== 0) { return; }
            	    var pid=prescgridds.getAt(0).get("pid") ;
                    OpenExpTotalWin(pid)
                }
                      
		    if (p.id=="2"){
                    var rows=reasongrid.getStore().getCount() ; 
				    if (rows== 0) { return; }
            	    var pid=reasongridds.getAt(0).get("pid") ;
                    OpenExpReaTotalWin(pid)
                }  
		    
}






///执行清除TMP
function Kill(pid)
{

         Ext.Ajax.request({
	
	         url:unitsUrl+'?action=KillQueryData&pid='+pid ,
		
		 	 scope: this
		
		
		});
}




///清除明细
function KillItm()
{
	var totalnum =commentitmgrid.getStore().getCount() ;
	if (totalnum!=0){
	       var pid=commentitmgridds.getAt(0).get("pid") ;
	       Kill(pid);
	   } 
}

///清除处方汇总
function KillTotal()
{
         var totalnum =prescgrid.getStore().getCount() ;
         if (totalnum!=0){
	       var pid=prescgridds.getAt(0).get("pid") ;
	       Kill(pid); 
		 } 
}

///清除原因汇总
function KillReaTotal()
{
         var totalnum =reasongrid.getStore().getCount() ;
         if (totalnum!=0){
	       var pid=reasongridds.getAt(0).get("pid") ;
	       Kill(pid); 
		 } 
}


///清除临时记录

document.body.onbeforeunload=function(e){

	            
                KillItm();
                KillTotal();
                KillReaTotal();
                
               
 

}


window.onbeforeunload=function checkLeave(e){
				var evt = e ? e : (window.event ? window.event : null);        //此方法为了在firefox中的兼容
                
                KillItm();
                KillTotal();
                KillReaTotal();
    
  }






});
                                                                                        