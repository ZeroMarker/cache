///סԺҽ������������JS
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

  Ext.QuickTips.init();// ������Ϣ��ʾ
  Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
  
 var oneTbar=new Ext.Toolbar({   
 region: 'center',
 items:[   
  
	 {xtype: 'tbtext',id:'baseDiag',text:'���:'},
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
  
	
     //����load Tab,����������
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
		
	
		
		//��ϸ
		if (p.id=="frameordquery"){
			 if (adm==0) return;
			
			 FindOrdDetailData(adm,pcntsitm);

		}
		

		//����ҽ��
		if (p.id=="frameadmordquery"){
		  //iframe.src=p.src + '?EpisodeID=' + adm ;
		  //iframe.src = 'oeorder.opbillinfo.csp' + '?EpisodeID=' + adm;
		  iframe.src='ipdoc.patorderview.csp'+'?EpisodeID=' + adm+'&PageShowFromWay=ShowFromEmrList&DefaultOrderPriorType=ALL'
		}
		
   }
   
   
                       
  var OkButton = new Ext.Button({
             width : 65,
             id:"OkButton",
             text: '����',
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
             text: '������',
             iconCls:"page_bad",
             listeners:{
                        "click":function(){
                            //EditReason();
                            unreasonCommont();
                        }
             }
             
             })
             
         
	//��ҩ����
	var OrderAnalyseButton = new Ext.Button({
	    width: 65,
	    id: "OrderAnalyseBtn",
	    text: '��ҩ����',
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
             text: '�鿴��־',
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
         text: '�鿴ȫ����־',
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
             text: '�鵥',
             listeners:{   
                          "click":function(){   
                             
                            FindCommentFun(2);
                              }   
                       } 
             
             
             
             })
 
  
    
   ///ҽ������table 

 
 var sm = new Ext.grid.CheckboxSelectionModel(); // add checkbox
 
 var nm = new Ext.grid.RowNumberer();
 
  var ordgridcm = new Ext.grid.ColumnModel([nm,     
        {header:'�ǼǺ�',dataIndex:'patno',width:100},
        {header:'����',dataIndex:'patname',width:90},   
        {header:'adm',dataIndex:'adm',hidden:true},
        {header:'���',dataIndex:'curret',width:110}, 
        {header:'waycode',dataIndex:'waycode',hidden:true},
        {header:'������id',dataIndex:'pcntsi',hidden:true},
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

 
 var ordgridcmPagingToolbar = new Ext.PagingToolbar({	//��ҳ����
			store:ordgridds,
			pageSize:200
			//��ʾ���½���Ϣ
			//displayInfo:true,
			//displayMsg:'��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
		        //prevText:"��һҳ",
			//nextText:"��һҳ",
			//refreshText:"ˢ��",
			//lastText:"���ҳ",
			//firstText:"��һҳ",
			//beforePageText:"��ǰҳ",
			//afterPageText:"��{0}ҳ",
    		        //emptyMsg: "û������"
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
    
     
    
    ///ҽ����ϸ����table
    

  var orddetailgridcm = new Ext.grid.ColumnModel({
  
  columns:[
        {header:'������ҩ',dataIndex: 'DrugUseImg',width: 75},
        {header:'ҽ������',dataIndex:'incidesc',width:250},
        {header:'����',dataIndex:'qty',width:40},
        {header:'��λ',dataIndex:'uomdesc',width:70},
        {header:'����',dataIndex:'dosage',width:60},
        {header:'Ƶ��',dataIndex:'freq',width:40},
        {header:'���',dataIndex:'spec',width:120,hidden:true},
        {header:'�÷�',dataIndex:'instruc',width:80},
        {header:'����',dataIndex:'form',width:80},
        {header:'ҽ�����ȼ�',dataIndex:'ordpri',width:80},
        {header:'����ҩ��',dataIndex:'basflag',width:70},
        {header:'ҽ��',dataIndex:'doctor',width:60},
        {header:'ҽ����������',dataIndex:'orddate',width:150},
        {header:'ҽ����ע',dataIndex:'remark',width:70},
        {header:'����',dataIndex:'manf',width:250,hidden:true},
        {header:'����',dataIndex:'price',width:60,hidden:true},
        {header:'���',dataIndex:'amt',width:80,hidden:true},
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
			//��ʾ���½���Ϣ
			displayInfo:true,
			displayMsg:'��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
		        prevText:"��һҳ",
			nextText:"��һҳ",
			refreshText:"ˢ��",
			lastText:"���ҳ",
			firstText:"��һҳ",
			beforePageText:"��ǰҳ",
			afterPageText:"��{0}ҳ",
    		        emptyMsg: "û������"
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



	
     ///�ұߵ�Form

	
     var toolform = new Ext.TabPanel({
        id:'ToolsTabPanel',
	    region: 'center',
	    margins:'3 3 0 3', 
	    frame:false,
	    activeTab: 0,
            items:[{
            	title: 'ҽ����ϸ',	
		id:'frameordquery',
		layout:'border',
		items: [orddetailgrid]
       		},{
	        		title: '������¼',	
					frameName: 'framepaallergy',
					html: '<iframe id="paallergyFrame" width=100% height=100% src=dhcpha.comment.paallergy.csp></iframe>',		
					src: 'dhcpha.comment.paallergy.csp',
					id:'framepaallergy'
	
	    },{
	          		title: '����¼',
	          		frameName: 'framerisquery',
	          		html: '<iframe id="framerisquery" width=100% height=100% src=dhcpha.comment.risquery.csp></iframe>',		
		  			src: 'dhcpha.comment.risquery.csp',
		  			id:'framerisquery'
	       
	
	    },{
	          		title: '�����¼',
	          		frameName: 'framelabquery',
	          		//html: '<iframe id="framelabquery" width=100% height=100% src=dhcpha.comment.labquery.csp></iframe>',		
		  			//src: 'dhcpha.comment.labquery.csp',
		  			html: '<iframe id="framelabquery" width=100% height=100% src=jquery.easyui.dhclaborder.csp></iframe>',		
		  			src: 'jquery.easyui.dhclaborder.csp',
		  			id:'framelabquery'
	       
	
	    },{
	          		title: '�������',
	          		frameName: 'frameprbrowser',
		  			//html: '<iframe id="frmeprbrowser" width=100% height=100% src=emr.interface.browse.category.csp></iframe>',		
		  			//src: 'emr.interface.browse.category.csp',
		  			html: '<iframe id="frmeprbrowser" width=100% height=100% src=emr.interface.browse.episode.csp></iframe>',		
		  			src: 'emr.interface.browse.episode.csp', //����	
		  			id:'frameprbrowser'
	       
	
	    },{
	          		title: '����ҽ��',
	          		frameName: 'frameadmordquery',
	          		html: '<iframe id="frameadmordquery" width=100% height=100% src=dhcpha.comment.admordquery.csp></iframe>',		
		  			src: 'dhcpha.comment.queryorditemds.csp',
		  			id:'frameadmordquery'
	       
	
	    }],
	    
	    
	    tbar: [
	        
	        '�ǼǺ�:',{xtype: 'tbtext',id:'baseInfoIPNo',height:'15',width:'90',text:'',cls:'x-panel-header'},'-',				
	        '����:',{xtype: 'tbtext',id:'baseInfoName',height:'15',width:'90',text:'',cls:'x-panel-header'},"-",
	        '�Ա�:',{xtype: 'tbtext',id:'baseInfoSex',height:'15',width:'40',text:'',cls:'x-panel-header'},"-",
	        '����:',{xtype: 'tbtext',id:'baseInfoAge',height:'15',width:'40',text:'',cls:'x-panel-header'},"-",
	        '����:',{xtype: 'tbtext',id:'baseInfoWeight',height:'15',width:'50',text:'',cls:'x-panel-header'},'-',
	        '�ѱ�:',{xtype: 'tbtext',id:'baseInfoType',height:'15',width:'50',text:'',cls:'x-panel-header'},"-",
	        '����:',{xtype: 'tbtext',id:'baseInfoLoc',height:'15',width:'150',text:'',cls:'x-panel-header'}
	   
	        
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
         title: '����סԺҽ��',
         collapsible: true,
         frame: false,
	 width:300,
         layout:'border', 
         defaults: {   
        	split: false              //�Ƿ��зָ���  
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




///�����б�grid �������¼�

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
    

///���´���(�����ѯ����)
function OpenMoreFindWindow()
{
   MoreFindFun();
}


///�鵥����,ѡȡ������,��������������


QueryCommontItm =function(PCNTSRowid,MainTitle,RetFlag)
{
                //ClearWindow();
                waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�..." }); 
                waitMask.show();
				ordgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryCommontItm&PCNTSRowid='+PCNTSRowid+'&RetFlag='+RetFlag });
				ordgridds.load({
				params:{start:0, limit:ordgridcmPagingToolbar.pageSize},
				callback: function(r, options, success){
		   
		
		                   waitMask.hide();
		                   if (success==false){
		                     	Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     } else{
		                           //westPanel.setTitle(MainTitle);
		                     }         
		           
		          }
		
		});

}



/// ����Adm�鿴ҽ����ϸ

function FindOrdDetailData(adm,pcntsitm)  
{
            
                orddetailgridds.removeAll();
				orddetailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindIPOrdDetailData&Adm='+adm+'&pcntsitm='+pcntsitm });		
				orddetailgridds.load({
				params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize},
				callback: function(r, options, success){
 
		         
		         
		         if (success==false){
		                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		         
		
		});
		
				
		
} 


///��PatInfo
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

///��Grid  1 ȫ��  2���ұ�grid
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

///����

function ClearWindow()
{
        ordgridds.removeAll();
		orddetailgridds.removeAll();
		ClearPatInfo();
		HrefRefresh();
}


///�ϸ�

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
           Ext.MessageBox.alert("��ʾ", "δѡ�м�¼!");
           return;
     }
     if (row==0){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ�м�¼!");
           return;
     }
     /*
      if (!(detailrow)){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ��ҩƷ��¼!");
           return;
     }
     if (detailrow==0){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ��ҩƷ��¼!");
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



///���ϸ�

function EditReason()
{

       var row = Ext.getCmp("ordgridtbl").getSelectionModel().getSelections(); 

       if (!(row)){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ�в����б��¼!");
           return;
       }
       if (row==0){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ�в����б��¼!");
           return;
       }
       
       var detailrow = Ext.getCmp("orddetailtbl").getSelectionModel().getSelections(); 


       if (!(detailrow)){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ��ҩƷ��¼!");
           return;
       }
       if (detailrow==0){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ��ҩƷ��¼!");
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
///���������
function unreasonCommont()
{
	///�Ƿ�ѡ���б�
	var row = Ext.getCmp("ordgridtbl").getSelectionModel().getSelections(); 
	if (!(row)){
		Ext.Msg.getDialog().setWidth(500);
		Ext.MessageBox.alert("��ʾ", "δѡ�в����б��¼!");
		return;
	}
	if (row==0){
		Ext.Msg.getDialog().setWidth(500); 
		Ext.MessageBox.alert("��ʾ", "δѡ�в����б��¼!");
		return;
	}
	///�Ƿ�ѡ��ҽ����
	var detailrow = Ext.getCmp("orddetailtbl").getSelectionModel().getSelections(); 
	if (!(detailrow)){
		Ext.Msg.getDialog().setWidth(500); 
		Ext.MessageBox.alert("��ʾ", "δѡ��ҩƷ��¼!");
		return;
	}
	if (detailrow==0){
		Ext.Msg.getDialog().setWidth(500); 
		Ext.MessageBox.alert("��ʾ", "δѡ��ҩƷ��¼!");
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
	///����������
	SaveCommontResult(reasondr,input);
}

///����������

function SaveCommontResult(reasondr,input)
{
        var currow = ordgrid.getSelectionModel().getSelected();
     	var pcntsi = currow.data.pcntsi;
     	var otherstr=pcntsi
        var curdetail=orddetailgrid.getSelectionModel().getSelected();
   
        var User=session['LOGON.USERID'] ;
        
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�..." ,removeMask: true}); 
        waitMask.show();
            
  		Ext.Ajax.request({

	        url:unitsUrl+'?action=SaveItmResultIP&Input='+encodeURI(input)+'&ReasonDr='+reasondr+'&OtherStr='+otherstr  ,
			failure: function(result, request) {
				waitMask.hide() ;
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
				  	msgtxt="�ѵ���,��û���޸ĵ�Ȩ��!"
				  }
				  else if (jsonData.retvalue="-44"){
				  	msgtxt="����ϸ�ѷ������ҩʦ,��û�е�������ϸ��Ȩ��!"
				  }
				  Ext.Msg.show({title:'��ʾ',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}			  	 
	  		
	  		

		},
		
			scope: this
		});

    
}




///ȡ���˻�����Ϣ

function GetInPatInfo(adm)
{

  		Ext.Ajax.request({

	    url:unitsUrl+'?action=GetInPatInfo&Adm='+adm ,
	
		waitMsg:'������...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
 ///�鿴��־	
 function ListLogBtnClick()
 {
 	   var detailrow = Ext.getCmp("orddetailtbl").getSelectionModel().getSelections(); 

       if (!(detailrow)){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ��ҩƷ��¼!");
           return;
       }
       if (detailrow==0){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ��ҩƷ��¼!");
           return;
       }
       
       var adm=PatInfo.adm;
       var orditm = detailrow[0].data.orditem;
       
       var mainrow = Ext.getCmp("ordgridtbl").getSelectionModel().getSelections(); 
       var pcntsitm = mainrow[0].data.pcntsi; 	//��ȡ�����ֱ�id
       
       FindItmLog(orditm,adm,pcntsitm);
 }
 
 ///�鿴������־
 function ListAllLogBtnClick()
 {
 	  var adm=PatInfo.adm;
 	  var mainrow = Ext.getCmp("ordgridtbl").getSelectionModel().getSelections(); 
      var pcntsitm = mainrow[0].data.pcntsi; 	//��ȡ�����ֱ�id
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
                    title: 'ע��',
                    msg: 'δ���ô��������ӿڣ����ڲ�������-����ҩ��-������ҩ�����������Ӧ����!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.INFO
                });
		return;
	}
	if (passType=="DHC"){
		// ����֪ʶ��
		/* DHCSTPHCMPASS.PassAnalysis({ 
		 	GridId: "grid-presc", 
		 	MOeori: "orditem",
		 	PrescNo:"prescno", 
		 	GridType: "JqGrid", 
		 	Field: "druguse",
		 	ResultField:"druguseresult"
		 });*/
	}else if (passType=="DT"){
		// ��ͨ
		 StartDaTongDll(); 
		 DaTongPrescAnalyse();  
	}else if (passType=="MK"){
		// ����
		MKPrescAnalyse(); 
	}else if (passType=="YY"){
	}
} 


/********************** ���ô�ͨ������ҩ start   **************************/
//��ͨ��������
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
        if (myrtn == 1) { var imgname = "warning1.gif"; }	// �Ƶ�
        if (myrtn == 2) { var imgname = "warning3.gif"; }	// �ڵ�
        record.set("datongflag", myrtn)
        var str = "<img id='DrugUseImg" + i + "'" + " src='../scripts/pharmacy/images/" + imgname + "'>";
        orddetailgrid.getView().getCell(i, 0).innerHTML = str;
    }
}

//�е���¼�
function orddetailgridcmClick(grid, rowIndex, columnIndex, e) {
    if (columnIndex == 2) {
        var record = orddetailgrid.getStore().getAt(rowIndex);
        var orditem = record.data.orditem;
        var myPrescXML = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongOutPresInfo", orditem);
        myrtn = dtywzxUI(28676, 1, myPrescXML);
    }
}


//��ʼ��
function StartDaTongDll() {
    dtywzxUI(0, 0, "");
}

function dtywzxUI(nCode, lParam, sXML) {
    var result;
    result = CaesarComponent.CRMS_UI(nCode, lParam, sXML, "");
    return result;
}

///��ͨҩ����ʾ
function DaTongYDTSBtnClick() {
    Ext.Msg.show({
        title: 'ע��',
        msg: '��Ҫ�͵�����������ҩ����ӿ�,��δ���� !',
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

/********************** ���ô�ͨ������ҩ end   **************************/
    
/********************** ��������������ҩ start   **************************/


//��ͨ��������
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
        if (myrtn == 0) { var imgname = "warning0.gif"; }	// ����
        if (myrtn == 1) { var imgname = "warning1.gif"; }	// �Ƶ�
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
	var XHZYRetCode=0  //������鷵�ش���
	MKXHZY1(prescno,flag);
	//��Ϊͬ������,ȡ��McPASS.ScreenHighestSlcode
	//��Ϊ�첽����,����ûص���������.
	//ͬ���첽ΪMcConfig.js MC_Is_SyncCheck true-ͬ��;false-�첽
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
            //alert("û����");
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
	ppi.PatCode = PatArr[0];			// ���˱���
	ppi.InHospNo= PatArr[11]
	ppi.VisitCode =PatArr[7]            // סԺ����
	ppi.Name = PatArr[1];				// ��������
	ppi.Sex = PatArr[2];				// �Ա�
	ppi.Birthday = PatArr[3];			// ��������
	
	ppi.HeightCM = PatArr[5];			// ���
	ppi.WeighKG = PatArr[6];			// ����
	ppi.DeptCode  = PatArr[8];			// סԺ����
	ppi.DeptName  =PatArr[12]
	ppi.DoctorCode =PatArr[13] ;		// ҽ��
	ppi.DoctorName =PatArr[9]
	ppi.PatStatus =1
	ppi.UseTime  = PatArr[4];		   	// ʹ��ʱ��
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
		//����core�ģ�������core���ر�Ƶ�Ψһ��ţ�����ĵ�div��idҲӦ�ú���������
        drug = new Params_Mc_Drugs_In();
        
        drug.Index = OrderArr[0];             			//ҩƷ���
        drug.OrderNo =OrderArr[0]; 		        		//ҽ����
        drug.DrugUniqueCode = OrderArr[1];  	//ҩƷ����
        drug.DrugName =  OrderArr[2]; 			//ҩƷ����
        drug.DosePerTime = OrderArr[3]; 	   //��������
		drug.DoseUnit =OrderArr[4];   	        //��ҩ��λ      
        drug.Frequency =OrderArr[5]; 	        //��ҩƵ��
        drug.RouteCode = OrderArr[8]; 	   		//��ҩ;������
        drug.RouteName = OrderArr[8];   		//��ҩ;������
		drug.StartTime = OrderArr[6];			//����ʱ��
        drug.EndTime = OrderArr[7]; 			//ͣ��ʱ��
        drug.ExecuteTime = ""; 	   				//ִ��ʱ��
		drug.GroupTag = OrderArr[10]; 	       //������
        drug.IsTempDrug = OrderArr[11];          //�Ƿ���ʱ��ҩ 0-���� 1-��ʱ
        drug.OrderType = 0;    //ҽ������� 0-����(Ĭ��);1-������;2-��ͣ��;3-��Ժ��ҩ
        drug.DeptCode = PrescMInfo[7].split("-")[1];     //�������ұ���
        drug.DeptName =  PrescMInfo[4]; 	  //������������
        drug.DoctorCode =PrescMInfo[6];   //����ҽ������
        drug.DoctorName =PrescMInfo[2];     //����ҽ������
		drug.RecipNo = "";            //������
        drug.Num = "";                //ҩƷ��������
        drug.NumUnit = "";            //ҩƷ����������λ          
        drug.Purpose = 0;             //��ҩĿ��(1Ԥ����2���ƣ�3Ԥ��+����, 0Ĭ��)  
        drug.OprCode = ""; //�������,���Ӧ������,��','����,��ʾ��ҩΪ�ñ�Ŷ�Ӧ��������ҩ
		drug.MediTime = ""; //��ҩʱ��(��ǰ,����,����)(0-δʹ��1- 0.5h����,2-0.5-2h,3-��2h)
		drug.Remark = "";             //ҽ����ע 
		arrayDrug[arrayDrug.length] = drug;
    
	}
	McDrugsArray = arrayDrug;
	var arrayAllergen = new Array();
	var pai;
	var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
	for(var i=0; i<AllergenInfoArr.length ;i++){
		var AllergenArr=AllergenInfoArr[i].split("^");
        
     	var allergen = new Params_Mc_Allergen_In();
     	allergen.Index = i;        //���  
      	allergen.AllerCode = AllergenArr[0];    //����
      	allergen.AllerName = AllergenArr[1];    //����  
      	allergen.AllerSymptom =AllergenArr[3]; //����֢״ 
      	 
		arrayAllergen[arrayAllergen.length] = allergen;
	}
	McAllergenArray = arrayAllergen;
	//����״̬������
	 var arrayMedCond = new Array();
	var pmi;
  	var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
	for(var i=0; i<MedCondInfoArr.length ;i++){			
		var MedCondArr=MedCondInfoArr[i].split("^");
       
      	var medcond;       
      	medcond = new Params_Mc_MedCond_In();
      	medcond.Index = i	;              			//������
     	medcond.DiseaseCode = MedCondArr[0];        //��ϱ���
      	medcond.DiseaseName = MedCondArr[1];     //�������
 		medcond.RecipNo = "";              //������
      	arrayMedCond[arrayMedCond.length] = medcond;     
      
	}
	var arrayoperation = new Array();
	McOperationArray = arrayoperation;
}

//********************** ��������������ҩ end   **************************/

//alert("LoadPCNTID1:"+LoadPCNTID)	
if (LoadPCNTID!=""){
	//alert("LoadPCNTID2:"+LoadPCNTID)
	QueryCommontItm(LoadPCNTID,"","");
  }	     

});
