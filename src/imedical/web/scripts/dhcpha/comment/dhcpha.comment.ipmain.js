///住院医嘱点评主界面JS
///Creator:LiangQiang
///CreatDate:2013-03-20
///
document.write("<object id='CaesarComponent' classid='clsid:8C028072-4FD2-46AE-B6D2-63E9F9B4155F' codebase = '../addins/client/dtywzxUIForMS.cab#version1.0.0.1'>");
document.write("</object>");
var unitsUrl = 'dhcpha.comment.main.save.csp';
var logonuser = session['LOGON.USERID'];
var logongroup = session['LOGON.GROUPID'];
var logonloc = session['LOGON.CTLOCID']

Ext.onReady(function() {

  Ext.QuickTips.init();// 浮动信息提示
  Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
  
 var oneTbar=new Ext.Toolbar({   
 region: 'center',
 items:[   
  
	 {xtype: 'tbtext',id:'baseDiag',text:'诊断:'},
	 {xtype: 'tbtext',id:'baseInfoDiag',height:'15',width:'650',text:'',cls:'x-panel-header'}
 
 ]  
 
 }); 
 
 

  
  PatInfo =  {
	    adm: 0,
        patientID:0,
        episodeID:0,
        admType:"I",
        prescno:0,
        orditem:0,
        pcntsitm:0
  };
  
	
     //重新load Tab,并加载数据
  var HrefRefresh = function (){
         
         
        var adm=PatInfo.adm; 
		var patientID=PatInfo.patientID
		var pcntsitm=PatInfo.pcntsitm
	        
		var p = Ext.getCmp("ToolsTabPanel").getActiveTab();	
		var iframe = p.el.dom.getElementsByTagName("iframe")[0];
		
		if (p.id=="framepaallergy"){
		  iframe.src = 'dhcdoc.allergyenter.csp' + '?PatientID=' + patientID +'&EpisodeID='+ adm ;
		}
		
		if (p.id=="framerisquery"){
		 iframe.src = ' dhcapp.inspectrs.csp' + '?PatientID=' + patientID +'&EpisodeID='+ adm ;
		}
		
		if (p.id=="framelabquery"){
		  iframe.src = 'dhcapp.seepatlis.csp' + '?PatientID=' + patientID +'&EpisodeID='+ adm+'&NoReaded='+'1';
		}
		
		if (p.id=="frameprbrowser"){
		  //iframe.src='dhc.epr.public.episodebrowser.csp?EpisodeID='+ adm;
		  var LocID=session['LOGON.CTLOCID'] ;
		  //iframe.src=p.src + '?PatientID=' + patientID + '&EpisodeID='+adm+'&EpisodeLocID=' + LocID;
		  iframe.src = 'emr.browse.csp'+ '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + LocID;
		}	
		
	
		
		//明细
		if (p.id=="frameordquery"){
			 if (adm==0) return;
			
			 FindOrdDetailData(adm,pcntsitm);

		}
		

		//本次医嘱
		if (p.id=="frameadmordquery"){
		  //iframe.src=p.src + '?EpisodeID=' + adm ;
		  //iframe.src = 'oeorder.opbillinfo.csp' + '?EpisodeID=' + adm;
		  iframe.src='ipdoc.patorderview.csp'+'?EpisodeID=' + adm+'&PageShowFromWay=ShowFromEmrList&DefaultOrderPriorType=ALL'
		}
		
   }
   
   
                       
  var OkButton = new Ext.Button({
             width : 65,
             id:"OkButton",
             text: '合理',
             iconCls:"page_ok",
             listeners:{
                          "click":function(){   
                             
                              CommontOk();
                              
                              }   
             }
             
             
             })
             
  var BadButton = new Ext.Button({
             width : 65,
             id:"BadButton",
             text: '不合理',
             iconCls:"page_bad",
             listeners:{
                        "click":function(){
                            //EditReason();
                            unreasonCommont();
                        }
             }
             
             })
             
         
	//用药分析
	var OrderAnalyseButton = new Ext.Button({
	    width: 65,
	    id: "OrderAnalyseBtn",
	    text: '用药分析',
	    iconCls: "page_analysis",
	    listeners: {
	        "click": function() {

	            OrderAnalyse();
	        }
	    }
	});
             
             
   var ListLogButton = new Ext.Button({
             width : 65,
             id:"ListLogBtn",
             text: '查看日志',
             iconCls:"page_log",
             listeners:{
                          "click":function(){   
                             
                              ListLogBtnClick();
                              
                              }   
             }
             
             
             })
             
  	var ListAllLogButton = new Ext.Button({
         width : 65,
         id:"ListAllLogBtn",
         text: '查看全部日志',
         iconCls:"page_log",
         listeners:{
                      "click":function(){   
                         
                          ListAllLogBtnClick();
                          
                          }   
         }
         
         
         })
             
             
 	var FindNoButton = new Ext.Button({
             width : 65,
             id:"FindNoButton",
             iconCls:"page_find",
             text: '查单',
             listeners:{   
                          "click":function(){   
                             
                            FindCommentFun(2);
                              }   
                       } 
             
             
             
             })
 
  
    
   ///医嘱数据table 

 
 var sm = new Ext.grid.CheckboxSelectionModel(); // add checkbox
 
 var nm = new Ext.grid.RowNumberer();
 
  var ordgridcm = new Ext.grid.ColumnModel([nm,     
        {header:'登记号',dataIndex:'patno',width:100},
        {header:'姓名',dataIndex:'patname',width:90},   
        {header:'adm',dataIndex:'adm',hidden:true},
        {header:'结果',dataIndex:'curret',width:110}, 
        {header:'waycode',dataIndex:'waycode',hidden:true},
        {header:'点评单id',dataIndex:'pcntsi',hidden:true},
        {header:'papmi',dataIndex:'papmi',hidden:true}
 
    ]);
 
 
    var ordgridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
	    'patno',
	    'patname',
	    'adm',
	    'curret',
	    'waycode',
	    'pcntsi',
	    'papmi'
	    
		]),
		
		

    remoteSort: true
});

 
 var ordgridcmPagingToolbar = new Ext.PagingToolbar({	//分页工具
			store:ordgridds,
			pageSize:200
			//显示右下角信息
			//displayInfo:true,
			//displayMsg:'当前记录 {0} -- {1} 条 共 {2} 条记录',
		        //prevText:"上一页",
			//nextText:"下一页",
			//refreshText:"刷新",
			//lastText:"最后页",
			//firstText:"第一页",
			//beforePageText:"当前页",
			//afterPageText:"共{0}页",
    		        //emptyMsg: "没有数据"
	}); 
	
	
 
 var ordgrid = new Ext.grid.GridPanel({

        stripeRows: true,
        id:'ordgridtbl',
        enableHdMenu : false,
        ds: ordgridds,
        cm: ordgridcm, 
        autoScroll:true,
        stripeRows: true,
        enableColumnMove : false,
        sm : sm,
		clicksToEdit :1,
        view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    // render rows as they come into viewable area.
		    scrollDelay: false
		    
		    
	    }),
	viewConfig:{	
		forceFit:true	
	},    
        tbar:[FindNoButton],
        bbar: ordgridcmPagingToolbar,
        trackMouseOver:'true' 
           
           
        

        
    });
    
     
    
    ///医嘱明细数据table
    

  var orddetailgridcm = new Ext.grid.ColumnModel({
  
  columns:[
        {header:'合理用药',dataIndex: 'DrugUseImg',width: 75},
        {header:'医嘱名称',dataIndex:'incidesc',width:250},
        {header:'数量',dataIndex:'qty',width:40},
        {header:'单位',dataIndex:'uomdesc',width:70},
        {header:'剂量',dataIndex:'dosage',width:60},
        {header:'频次',dataIndex:'freq',width:40},
        {header:'规格',dataIndex:'spec',width:120,hidden:true},
        {header:'用法',dataIndex:'instruc',width:80},
        {header:'剂型',dataIndex:'form',width:80},
        {header:'医嘱优先级',dataIndex:'ordpri',width:80},
        {header:'基本药物',dataIndex:'basflag',width:70},
        {header:'医生',dataIndex:'doctor',width:60},
        {header:'医嘱开单日期',dataIndex:'orddate',width:150},
        {header:'医嘱备注',dataIndex:'remark',width:70},
        {header:'厂家',dataIndex:'manf',width:250,hidden:true},
        {header:'单价',dataIndex:'price',width:60,hidden:true},
        {header:'金额',dataIndex:'amt',width:80,hidden:true},
        {header:'orditem',dataIndex:'orditem',hidden:true},
        {header:'prescno',dataIndex:'prescno',width:150,hidden:true},
        {header:'colorflag',dataIndex:'colorflag',hidden:true}
        
          ]   
            
    
    });
 
 
    var orddetailgridds = new Ext.data.Store({
		proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
        	'DrugUseImg',
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
		    'prescno',
		    'colorflag'
	    
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
        
        region:'center',
        margins:'3 3 3 3', 
        autoScroll:true,
        stripeRows: true,
        id:'orddetailtbl',
        ds: orddetailgridds,
        cm: orddetailgridcm,
        enableColumnMove : false,
        view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    // render rows as they come into viewable area.
		    scrollDelay: false,
		    getRowClass: function(record, index, rowParams, store) {  
			   if (record.data.colorflag > 0) {		   
			   		return 'x-grid-record-pink'; 		   
			   }
		   
		   }
		    
		    
	    }),
	viewConfig:{	
		forceFit:true	
	},
        tbar:[OkButton,"-",BadButton,"-",OrderAnalyseButton,"-",ListLogButton,'-',ListAllLogButton],
        bbar: orddetailgridcmPagingToolbar,
        trackMouseOver:'true'
        

        
    });
  
/*
ordgrid.on('afterlayout',function(view,layout){   
  
   // ordgrid.setHeight(document.body.clientHeight-55)
    
},this);

*/



	
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
	          		//html: '<iframe id="framelabquery" width=100% height=100% src=dhcpha.comment.labquery.csp></iframe>',		
		  			//src: 'dhcpha.comment.labquery.csp',
		  			html: '<iframe id="framelabquery" width=100% height=100% src=jquery.easyui.dhclaborder.csp></iframe>',		
		  			src: 'jquery.easyui.dhclaborder.csp',
		  			id:'framelabquery'
	       
	
	    },{
	          		title: '病历浏览',
	          		frameName: 'frameprbrowser',
		  			//html: '<iframe id="frmeprbrowser" width=100% height=100% src=emr.interface.browse.category.csp></iframe>',		
		  			//src: 'emr.interface.browse.category.csp',
		  			html: '<iframe id="frmeprbrowser" width=100% height=100% src=emr.interface.browse.episode.csp></iframe>',		
		  			src: 'emr.interface.browse.episode.csp', //可用	
		  			id:'frameprbrowser'
	       
	
	    },{
	          		title: '本次医嘱',
	          		frameName: 'frameadmordquery',
	          		html: '<iframe id="frameadmordquery" width=100% height=100% src=dhcpha.comment.admordquery.csp></iframe>',		
		  			src: 'dhcpha.comment.queryorditemds.csp',
		  			id:'frameadmordquery'
	       
	
	    }],
	    
	    
	    tbar: [
	        
	        '登记号:',{xtype: 'tbtext',id:'baseInfoIPNo',height:'15',width:'90',text:'',cls:'x-panel-header'},'-',				
	        '姓名:',{xtype: 'tbtext',id:'baseInfoName',height:'15',width:'90',text:'',cls:'x-panel-header'},"-",
	        '性别:',{xtype: 'tbtext',id:'baseInfoSex',height:'15',width:'40',text:'',cls:'x-panel-header'},"-",
	        '年龄:',{xtype: 'tbtext',id:'baseInfoAge',height:'15',width:'40',text:'',cls:'x-panel-header'},"-",
	        '体重:',{xtype: 'tbtext',id:'baseInfoWeight',height:'15',width:'50',text:'',cls:'x-panel-header'},'-',
	        '费别:',{xtype: 'tbtext',id:'baseInfoType',height:'15',width:'50',text:'',cls:'x-panel-header'},"-",
	        '科室:',{xtype: 'tbtext',id:'baseInfoLoc',height:'15',width:'150',text:'',cls:'x-panel-header'}
	   
	        
	    ],
	    
	    listeners:{ 
                              tabchange:function(tp,p){ 
                                          HrefRefresh() ;
                                    }  ,
			      'render' : function(){   
					           oneTbar.render(this.tbar); //add one tbar   
					    
					          }
                                
                      } 

	    
	    
	  
	    
	    
	});
	


	
	


    toolform.on('afterlayout',function(view,layout){   
	  
	    
	    //toolform.setHeight(document.body.clientHeight)
	    
	},this);
	

 
     
     var westPanel = new Ext.Panel({
         region: 'west',       
         title: '点评住院医嘱',
         collapsible: true,
         frame: false,
	 width:300,
         layout:'border', 
         defaults: {   
        	split: false              //是否有分割线  
                //bodyStyle: 'padding:0.5px' 
                 },
         items : [{
         	region:'center',  
         	layout:'fit',  
         	items:[ordgrid]
         	
         	}]
 
     });
     
     

     
     


      var port = new Ext.Viewport({

				layout : 'border',
				items : [westPanel,toolform]

			});


////-----------------Events-----------------///




///处方列表grid 单击行事件

ordgrid.on('rowclick',function(grid,rowIndex,e){
        var selectedRow = ordgridds.data.items[rowIndex]
		var adm = selectedRow.data["adm"];
		var papmi = selectedRow.data["papmi"];
		var pcntsitm = selectedRow.data["pcntsi"];
        PatInfo.adm=adm;
        PatInfo.patientID=papmi;
        PatInfo.pcntsitm=pcntsitm
        GetInPatInfo(adm);
		HrefRefresh(); 
    });  
    

///打开新窗体(更多查询条件)
function OpenMoreFindWindow()
{
   MoreFindFun();
}


///查单界面,选取点评单,调出点评单内容


QueryCommontItm =function(PCNTSRowid,MainTitle,RetFlag)
{
                //ClearWindow();
                waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." }); 
                waitMask.show();
				ordgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryCommontItm&PCNTSRowid='+PCNTSRowid+'&RetFlag='+RetFlag });
				ordgridds.load({
				params:{start:0, limit:ordgridcmPagingToolbar.pageSize},
				callback: function(r, options, success){
		   
		
		                   waitMask.hide();
		                   if (success==false){
		                     	Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     } else{
		                           //westPanel.setTitle(MainTitle);
		                     }         
		           
		          }
		
		});

}



/// 根据Adm查看医嘱明细

function FindOrdDetailData(adm,pcntsitm)  
{
            
                orddetailgridds.removeAll();
				orddetailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindIPOrdDetailData&Adm='+adm+'&pcntsitm='+pcntsitm });		
				orddetailgridds.load({
				params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize},
				callback: function(r, options, success){
 
		         
		         
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

///清Grid  1 全清  2清右边grid
function ClearGrid(flag)
{ 
       
        if (flag==1) {
         	ordgridds.removeAll();
        }
	  
		//orddetailgridds.removeAll();
		orddetailgridds.load({params:{start:0,limit:0,Adm:""}})
	    ClearPatInfo();
		HrefRefresh();
		
}

///清屏

function ClearWindow()
{
        ordgridds.removeAll();
		orddetailgridds.removeAll();
		ClearPatInfo();
		HrefRefresh();
}


///合格

function CommontOk()
{

	

     var row = Ext.getCmp("ordgridtbl").getSelectionModel().getSelections(); 
     var detailrow = Ext.getCmp("orddetailtbl").getSelectionModel().getSelections(); 
     var orditm=""
	 if (detailrow!=0){
	  	var orditm = detailrow[0].data.orditem; 
     }
     
     if (!(row)){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("提示", "未选中记录!");
           return;
     }
     if (row==0){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("提示", "未选中记录!");
           return;
     }
     /*
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
     */
     //var orditm = "";
     var ret="Y";
     var reasondr="";
     var advicetxt="";
     var factxt="";
     var phnote="";
     var User=session['LOGON.USERID'] ;
	 var grpdr=session['LOGON.GROUPID'] ;
		
		
	 var input=PatInfo.adm+"^"+ret+"^"+User+"^"+advicetxt+"^"+factxt+"^"+phnote+"^"+grpdr+"^"+orditm;
     
     SaveCommontResult(reasondr,input)
     
 
}



///不合格

function EditReason()
{

       var row = Ext.getCmp("ordgridtbl").getSelectionModel().getSelections(); 

       if (!(row)){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("提示", "未选中病人列表记录!");
           return;
       }
       if (row==0){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("提示", "未选中病人列表记录!");
           return;
       }
       
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
       var waycode = row[0].data.waycode;
       
    
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
		
		
		var input=PatInfo.adm+"^"+ret+"^"+User+"^"+advicetxt+"^"+factxt+"^"+phnote+"^"+grpdr+"^"+orditm;
		
		if (reasondr.indexOf("$$$")=="-1")
		{
			reasondr=reasondr+"$$$"+orditm ;
		}
		
		SaveCommontResult(reasondr,input) 
       

}
///不合理点评
function unreasonCommont()
{
	///是否选择列表
	var row = Ext.getCmp("ordgridtbl").getSelectionModel().getSelections(); 
	if (!(row)){
		Ext.Msg.getDialog().setWidth(500);
		Ext.MessageBox.alert("提示", "未选中病人列表记录!");
		return;
	}
	if (row==0){
		Ext.Msg.getDialog().setWidth(500); 
		Ext.MessageBox.alert("提示", "未选中病人列表记录!");
		return;
	}
	///是否选择医嘱项
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
      
	var rows=Ext.getCmp("orddetailtbl").getSelectionModel().getSelections(); 
	var orditmArr=[];
	for(var i=0;i<rows.length;i++){
		orditmArr.push(rows[i].data.orditem);
	}
	var orditmList=orditmArr.join("^");

    //var orditm = detailrow[0].data.orditem;
    var waycode = row[0].data.waycode;
    
    var retstr=showModalDialog('dhcpha.comment.selectreason.csp?orditm='+orditmList+'&waycode='+waycode+'&prescnostr='+"",'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')    
 
    if (!(retstr)){ return;}

    retarr=retstr.split("@");

    var ret="N";
	var reasondr=retarr[0];
	var advicetxt=retarr[2];
	var factxt=retarr[1];
	var phnote=retarr[3];
	var User=session['LOGON.USERID'] ;
	var grpdr=session['LOGON.GROUPID'] ;
		
		
	var input=PatInfo.adm+"^"+ret+"^"+User+"^"+advicetxt+"^"+factxt+"^"+phnote+"^"+grpdr+"^"+orditmList;  //orditm;
	
	if (reasondr.indexOf("$$$")=="-1"){
		reasondr=reasondr+"$$$"+orditmList;  //orditm;
	}
	///保存点评结果
	SaveCommontResult(reasondr,input);
}

///保存点评结果

function SaveCommontResult(reasondr,input)
{
        var currow = ordgrid.getSelectionModel().getSelected();
     	var pcntsi = currow.data.pcntsi;
     	var otherstr=pcntsi
        var curdetail=orddetailgrid.getSelectionModel().getSelected();
   
        var User=session['LOGON.USERID'] ;
        
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." ,removeMask: true}); 
        waitMask.show();
            
  		Ext.Ajax.request({

	        url:unitsUrl+'?action=SaveItmResultIP&Input='+encodeURI(input)+'&ReasonDr='+reasondr+'&OtherStr='+otherstr  ,
			failure: function(result, request) {
				waitMask.hide() ;
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
			success: function(result, request) {
	            waitMask.hide() ;
				var jsonData = Ext.util.JSON.decode( result.responseText );
				
				if (jsonData.retvalue==0){
	
					       var arr=input.split("^");
					       var result=arr[1];
					       if (result=="Y"){
					            //ordgridds.remove( currow ); 
	                            ClearGrid();
	                            ordgridds.reload() ;
					       }
					       else{
					       	     	var row = Ext.getCmp("orddetailtbl").getSelectionModel().getSelections();
									var rowindex = orddetailgrid.getStore().indexOf(row[0]);
	     							orddetailgrid.getView().getRow(rowindex).style.backgroundColor="#FFB5C5"
					       			ordgridds.reload();
					       			orddetailgridds.removeAll();
	
					       }
	                            
						
				  
				}else{
				  msgtxt=jsonData.retinfo;
				  if (jsonData.retvalue="-33"){
				  	msgtxt="已点评,您没有修改的权限!"
				  }
				  else if (jsonData.retvalue="-44"){
				  	msgtxt="该明细已分配点评药师,您没有点评此明细的权限!"
				  }
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
       
       var mainrow = Ext.getCmp("ordgridtbl").getSelectionModel().getSelections(); 
       var pcntsitm = mainrow[0].data.pcntsi; 	//获取点评字表id
       
       FindItmLog(orditm,adm,pcntsitm);
 }
 
 ///查看所有日志
 function ListAllLogBtnClick()
 {
 	  var adm=PatInfo.adm;
 	  var mainrow = Ext.getCmp("ordgridtbl").getSelectionModel().getSelections(); 
      var pcntsitm = mainrow[0].data.pcntsi; 	//获取点评字表id
 	  FindItmLog("",adm,pcntsitm) ;
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
		
		//orddetailgridds.removeAll();
		orddetailgridds.load({params:{start:0,limit:0,Adm:""}})
	} 
  
    
function OrderAnalyse(){
	var passType="MK"		//tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",logongroup,logonloc,logonuser);
	if (passType==""){
		Ext.Msg.show({
                    title: '注意',
                    msg: '未设置处方分析接口，请在参数设置-门诊药房-合理用药厂商中添加相应厂商!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.INFO
                });
		return;
	}
	if (passType=="DHC"){
		// 东华知识库
		/* DHCSTPHCMPASS.PassAnalysis({ 
		 	GridId: "grid-presc", 
		 	MOeori: "orditem",
		 	PrescNo:"prescno", 
		 	GridType: "JqGrid", 
		 	Field: "druguse",
		 	ResultField:"druguseresult"
		 });*/
	}else if (passType=="DT"){
		// 大通
		 StartDaTongDll(); 
		 DaTongPrescAnalyse();  
	}else if (passType=="MK"){
		// 美康
		MKPrescAnalyse(); 
	}else if (passType=="YY"){
	}
} 


/********************** 调用大通合理用药 start   **************************/
//大通处方分析
function DaTongPrescAnalyse() {
    var totalnum = orddetailgrid.getStore().getCount();
    if (totalnum == 0) {
        return;
    }
    for (var i = 0; i < totalnum; i++) {
        var record = orddetailgrid.getStore().getAt(i);
        var prescno = record.data.prescno;
        var datongflag = record.data.datongflag;
        var baseinfo = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDocBaseInfoByPresc", prescno);
        var myPrescXML = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescInfoXML", prescno);
        myrtn = dtywzxUI(6, baseinfo, myPrescXML);
        if (myrtn == 0) { var imgname = "warning0.gif"; }
        if (myrtn == 1) { var imgname = "warning1.gif"; }	// 黄灯
        if (myrtn == 2) { var imgname = "warning3.gif"; }	// 黑灯
        record.set("datongflag", myrtn)
        var str = "<img id='DrugUseImg" + i + "'" + " src='../scripts/pharmacy/images/" + imgname + "'>";
        orddetailgrid.getView().getCell(i, 0).innerHTML = str;
    }
}

//列点击事件
function orddetailgridcmClick(grid, rowIndex, columnIndex, e) {
    if (columnIndex == 2) {
        var record = orddetailgrid.getStore().getAt(rowIndex);
        var orditem = record.data.orditem;
        var myPrescXML = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongOutPresInfo", orditem);
        myrtn = dtywzxUI(28676, 1, myPrescXML);
    }
}


//初始化
function StartDaTongDll() {
    dtywzxUI(0, 0, "");
}

function dtywzxUI(nCode, lParam, sXML) {
    var result;
    result = CaesarComponent.CRMS_UI(nCode, lParam, sXML, "");
    return result;
}

///大通药典提示
function DaTongYDTSBtnClick() {
    Ext.Msg.show({
        title: '注意',
        msg: '需要和第三方合理用药软件接口,暂未开放 !',
        buttons: Ext.Msg.OK,
        icon: Ext.MessageBox.INFO
    });
    return;
    var rows = Ext.getCmp("orddetailgridtbl").getSelectionModel().getSelections(); // modified by myq 20150518 ordgridtbl->orddetailgridtbl
    var totalnum = rows.length;
    if (totalnum == 0) {
        return;
    }
    var currow = orddetailgrid.getSelectionModel().getSelected();
    var orditm = currow.get("oeorditm");
    dtywzxUI(3, 0, "");
    var myPrescXML = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDTYDTS", orditm);
    myrtn = dtywzxUI(12, 0, myPrescXML);
}

/********************** 调用大通合理用药 end   **************************/
    
/********************** 调用美康合理用药 start   **************************/


//大通处方分析
function MKPrescAnalyse() {
    var totalnum = orddetailgrid.getStore().getCount();
    if (totalnum == 0) {
        return;
    }
    for (var i = 0; i < totalnum; i++) {
        var record = orddetailgrid.getStore().getAt(i);
        var prescno = record.data.prescno;
        myrtn = HLYYPreseCheck(prescno,0); 
        var imgname = ""
        if (myrtn == 0) { var imgname = "warning0.gif"; }	// 合理
        if (myrtn == 1) { var imgname = "warning1.gif"; }	// 黄灯
        if (myrtn == 2) { var imgname = "warning2.gif"; }	// 
        if (myrtn == 3) { var imgname = "warning3.gif"; }	// 
        if (myrtn == 4) { var imgname = "warning4.gif"; }	// 
        if (imgname == "") { var imgname = myrtn }
        record.set("datongflag", myrtn)
        var str = "<img id='DrugUseImg" + i + "'" + " src='../scripts/pharmacy/images/" + imgname + "'>";
        orddetailgrid.getView().getCell(i, 0).innerHTML = str;
    }
}


function HLYYPreseCheck(prescno,flag){
	var XHZYRetCode=0  //处方检查返回代码
	MKXHZY1(prescno,flag);
	//若为同步处理,取用McPASS.ScreenHighestSlcode
	//若为异步处理,需调用回调函数处理.
	//同步异步为McConfig.js MC_Is_SyncCheck true-同步;false-异步
	XHZYRetCode=McPASS.ScreenHighestSlcode;
	return XHZYRetCode	
}

function MKXHZY1(prescno,flag){
	MCInit1(prescno);
	HisScreenData1(prescno);
	MDC_DoCheck(HIS_dealwithPASSCheck,flag);
}

function MCInit1(prescno) {
	var PrescStr=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
	var prescdetail=PrescStr.split("^")
	var pass = new Params_MC_PASSclient_In();
    pass.HospID = prescdetail[0];  
    pass.UserID = prescdetail[1];
    pass.UserName = prescdetail[2];
    pass.DeptID = prescdetail[3];
    pass.DeptName = prescdetail[4];
    pass.CheckMode ="mzyf"  //MC_global_CheckMode;
    MCPASSclient = pass;
}

function HIS_dealwithPASSCheck(result) {
        if (result > 0) {
        }
        else {
            //alert("没问题");
        }

	return result ;
}


function HisScreenData1(prescno){
	var Orders="";
	var Para1=""
	
	var PrescMStr=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
	var PrescMInfo=PrescMStr.split("^")
	var Orders=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescDetailInfo", prescno);
	if (Orders==""){return;}
	var DocName=PrescMInfo[2];
	var EpisodeID=PrescMInfo[5];
	if (EpisodeID==""){return}
	var ret=tkMakeServerCall("web.DHCHLYY","GetPrescInfo",EpisodeID,Orders,DocName);
	var TempArr=ret.split(String.fromCharCode(2));
	var PatInfo=TempArr[0];
	var MedCondInfo=TempArr[1];
	var AllergenInfo=TempArr[2];
	var OrderInfo=TempArr[3];
	var PatArr=PatInfo.split("^");
	
	
	var ppi = new Params_MC_Patient_In();
	ppi.PatCode = PatArr[0];			// 病人编码
	ppi.InHospNo= PatArr[11]
	ppi.VisitCode =PatArr[7]            // 住院次数
	ppi.Name = PatArr[1];				// 病人姓名
	ppi.Sex = PatArr[2];				// 性别
	ppi.Birthday = PatArr[3];			// 出生年月
	
	ppi.HeightCM = PatArr[5];			// 身高
	ppi.WeighKG = PatArr[6];			// 体重
	ppi.DeptCode  = PatArr[8];			// 住院科室
	ppi.DeptName  =PatArr[12]
	ppi.DoctorCode =PatArr[13] ;		// 医生
	ppi.DoctorName =PatArr[9]
	ppi.PatStatus =1
	ppi.UseTime  = PatArr[4];		   	// 使用时间
	ppi.CheckMode = MC_global_CheckMode
	ppi.IsDoSave = 1
	MCpatientInfo  = ppi;
    var arrayDrug = new Array();
	var pri;
  	var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
  	//alert(OrderInfo)
  	McRecipeCheckLastLightStateArr = new Array();
	for(var i=0; i<OrderInfoArr.length ;i++){    
		var OrderArr=OrderInfoArr[i].split("^");
		//传给core的，并且由core返回变灯的唯一编号，构造的灯div的id也应该和这个相关联
        drug = new Params_Mc_Drugs_In();
        
        drug.Index = OrderArr[0];             			//药品序号
        drug.OrderNo =OrderArr[0]; 		        		//医嘱号
        drug.DrugUniqueCode = OrderArr[1];  	//药品编码
        drug.DrugName =  OrderArr[2]; 			//药品名称
        drug.DosePerTime = OrderArr[3]; 	   //单次用量
		drug.DoseUnit =OrderArr[4];   	        //给药单位      
        drug.Frequency =OrderArr[5]; 	        //用药频次
        drug.RouteCode = OrderArr[8]; 	   		//给药途径编码
        drug.RouteName = OrderArr[8];   		//给药途径名称
		drug.StartTime = OrderArr[6];			//开嘱时间
        drug.EndTime = OrderArr[7]; 			//停嘱时间
        drug.ExecuteTime = ""; 	   				//执行时间
		drug.GroupTag = OrderArr[10]; 	       //成组标记
        drug.IsTempDrug = OrderArr[11];          //是否临时用药 0-长期 1-临时
        drug.OrderType = 0;    //医嘱类别标记 0-在用(默认);1-已作废;2-已停嘱;3-出院带药
        drug.DeptCode = PrescMInfo[7].split("-")[1];     //开嘱科室编码
        drug.DeptName =  PrescMInfo[4]; 	  //开嘱科室名称
        drug.DoctorCode =PrescMInfo[6];   //开嘱医生编码
        drug.DoctorName =PrescMInfo[2];     //开嘱医生姓名
		drug.RecipNo = "";            //处方号
        drug.Num = "";                //药品开出数量
        drug.NumUnit = "";            //药品开出数量单位          
        drug.Purpose = 0;             //用药目的(1预防，2治疗，3预防+治疗, 0默认)  
        drug.OprCode = ""; //手术编号,如对应多手术,用','隔开,表示该药为该编号对应的手术用药
		drug.MediTime = ""; //用药时机(术前,术中,术后)(0-未使用1- 0.5h以内,2-0.5-2h,3-于2h)
		drug.Remark = "";             //医嘱备注 
		arrayDrug[arrayDrug.length] = drug;
    
	}
	McDrugsArray = arrayDrug;
	var arrayAllergen = new Array();
	var pai;
	var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
	for(var i=0; i<AllergenInfoArr.length ;i++){
		var AllergenArr=AllergenInfoArr[i].split("^");
        
     	var allergen = new Params_Mc_Allergen_In();
     	allergen.Index = i;        //序号  
      	allergen.AllerCode = AllergenArr[0];    //编码
      	allergen.AllerName = AllergenArr[1];    //名称  
      	allergen.AllerSymptom =AllergenArr[3]; //过敏症状 
      	 
		arrayAllergen[arrayAllergen.length] = allergen;
	}
	McAllergenArray = arrayAllergen;
	//病生状态类数组
	 var arrayMedCond = new Array();
	var pmi;
  	var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
	for(var i=0; i<MedCondInfoArr.length ;i++){			
		var MedCondArr=MedCondInfoArr[i].split("^");
       
      	var medcond;       
      	medcond = new Params_Mc_MedCond_In();
      	medcond.Index = i	;              			//诊断序号
     	medcond.DiseaseCode = MedCondArr[0];        //诊断编码
      	medcond.DiseaseName = MedCondArr[1];     //诊断名称
 		medcond.RecipNo = "";              //处方号
      	arrayMedCond[arrayMedCond.length] = medcond;     
      
	}
	var arrayoperation = new Array();
	McOperationArray = arrayoperation;
}

//********************** 调用美康合理用药 end   **************************/

//alert("LoadPCNTID1:"+LoadPCNTID)	
if (LoadPCNTID!=""){
	//alert("LoadPCNTID2:"+LoadPCNTID)
	QueryCommontItm(LoadPCNTID,"","");
  }	     

});
