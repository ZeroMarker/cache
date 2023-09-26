
var unitsUrl = 'DHCST.PIVAOUT.SAVEURL.csp';


Ext.onReady(function() {

	Ext.QuickTips.init();// 浮动信息提示
	
        var Request = new Object();
        Request = GetRequest();
        var orditmstr = Request['orditmstr'];
        var waycode = Request['waycode'];

        var BedButton = new Ext.Button({
             width : 65,
             id:"ComBedBtn",
             text: '保存',
             icon:"../scripts/dhcpha/img/addwl.gif",
             listeners:{
                          "click":function(){   
                             
                              SaveReason();
                              
                              }   
             }
             
         })
         
	  

        
        var ReasonFactorDs = new Ext.data.Store({
		autoLoad: true,
		proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=GetReasonFactorDs',
			method : 'POST'
		}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'facrowid'},['facdesc','facrowid'])
				
          }); 
        



	// 创建一个简写

	var Tree = Ext.tree;

	// 定义根节点的Loader

	var treeloader = new Tree.TreeLoader({

				dataUrl : unitsUrl + '?action=ListTreeData'

			});

	// 添加一个树形面板

	var treepanel = new Tree.TreePanel({

				//el : 'tree-panel',// 

				region : 'west',

				title : '第一步:选择不合格原因',

				width : 400,

				//minSize : 180,

				//maxSize : 250,

				split : true,

				//autoHeight : true,
				
				height : 300,

				frame : true,

				autoScroll : true,

				enableDD : false,

				containerScroll : true,

				rootVisible : true,

				border : true,

				animate : true,
				
				rootVisible:false,

				loader : treeloader,
				
				tbar:['提示: 双 击 操 作']

			});

	// 异步加载根节点

	var rootnode = new Tree.AsyncTreeNode({

				text : 'root',

				id : 'id',

				value : '0',

				level : '0',

				draggable : false , // 根节点不容许拖动

				expanded : true

			});

	// 为tree设置根节点

	treepanel.setRootNode(rootnode);

	// 响应加载前事件，传递node参数

	treeloader.on('beforeload', function(treeloader, node) {

				if (node == rootnode) {
					node.attributes.id = '0';
				}

				treeloader.baseParams = {
					id : node.attributes.id,
					level : node.attributes.level,
					waycode:waycode,
					actiontype : 'load'
				}

			}, this);;

	// 设置树的点击事件

	function treeClick(node, e) {
	
                 if (node.isLeaf()){
                    TreeNodeClickEvent(node.attributes.id,node.text);
                 }

		//if (node.isLeaf()) {

			//e.stopEvent();
                        //Ext.getCmp('IncitmSelecter').clearValue();
			//FindItmDetail(node.attributes.level, node.id, "")
			//alert(node.attributes.level)
			//alert(node.id)

		//}

	}

	// 增加鼠标单击事件

	treepanel.on('dblclick', treeClick);
	

	
   
   
   //Center
  var orditmgridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'医嘱名称',dataIndex:'DrugDesc',width:300},
        {header:'rowid',dataIndex:'DrugID',width:40} 
          ]   
            
    
    });
 
 
    var orditmgridds = new Ext.data.Store({
	    autoLoad: true,
	    proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=GetBedOrdItmDs&orditmstr='+orditmstr,
			method : 'POST'
		}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'DrugDesc',
            'DrugID'
	    
		]),
		
		

        remoteSort: true
});


 
 var orditmgrid = new Ext.grid.GridPanel({
   
 	    title:'第二步:选择原因相关联的医嘱',
 	    tbar:['提示: 双 击 操 作'],
        id:'orditmtbl',
        region: 'center', 
        stripeRows: true,
        width:150,
        height : 350,
        //autoScroll:true,
        margins:'0 3 0 1', 
        enableHdMenu : false,
        ds: orditmgridds,
        cm: orditmgridcm,
        enableColumnMove : false,


        trackMouseOver:'true'
        

        
    });
    
    
    orditmgrid.on('rowclick',function(grid,rowIndex,e){

        var selectedRow = orditmgridds.data.items[rowIndex];
		var inci = selectedRow.data["DrugID"];
        var incidesc = selectedRow.data["DrugDesc"];  
	    DrugSelectEvent(inci,incidesc);
  
		
		
    });   
	
  //east
	
	
   var selectreasongridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'描述',dataIndex:'reasondesc',width:300},
        {header:'rowid',dataIndex:'reasonrowid',width:40},
        {header:'分级',dataIndex:'reasonlevel',width:40}  
          ]   
            
    
    });
 
 
    var selectreasongridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'reasondesc',
            'reasonrowid',
            'reasonlevel'
	    
		]),
		
		

        remoteSort: true
});


 
 var selectreasongrid = new Ext.grid.GridPanel({
   
        id:'selreagrid',
        stripeRows: true,
        width:400,
        height : 350,
        //autoScroll:true,
        enableHdMenu : false,
        ds: selectreasongridds,
        cm: selectreasongridcm,
        enableColumnMove : false,
 
	    tbar:['提示: 双 击 取 消','-',BedButton],
        trackMouseOver:'true'
        

        
    });
    

              	  
 

	var eastPanel = new Ext.Panel({
        region: 'east',        //指定在东部
        title: '第三步:保存,生成问题列表',
        width: 400,
        margins:'0 0 0 0',
        items : [selectreasongrid]
      });
        ///view

	var por = new Ext.Viewport({

				layout : 'border', // 使用border布局

				items : [treepanel,orditmgrid,eastPanel]

			});





        ///-----------------------Events----------------------

	//选择树事件
	function TreeNodeClickEvent(nodeid,nodedesc)
	{               
	                if (nodeid==0){
	                 return;
	                }
	                var totalnum =selectreasongrid.getStore().getCount() ;
			for(var i=0;i<totalnum;i++){		      
			        var reasondr=selectreasongridds.getAt(i).get("reasonrowid") ;	  	        
		  		if (reasondr==nodeid){	  		     
		  		     Ext.Msg.show({title:'提示',msg:'已存在,不能重复添加',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		  		     return;
		  		}
			}
	
	                var newselreagridds = selectreasongrid.getStore().recordType;
	                var p = new newselreagridds({
	                    reasondesc: nodedesc,
	                    reasonrowid: nodeid,
	                    reasonlevel:''
	                });
	                selectreasongrid.stopEditing();
	                //selectreasongridds.insert(0, p);
	                selectreasongridds.insert(totalnum, p);	                
	                //selectreasongrid.startEditing(0, 0);
	}


	///双击grid去除原因事件   
	 
	selectreasongrid.on('rowdblclick',function(grid,rowIndex,e){
	
		    selectedRow = selectreasongrid.getSelectionModel().getSelected(); 
			if ( selectedRow ){ 

				    var totalnum =selectreasongrid.getStore().getCount() ;
				   
					for(var i=(rowIndex+1);i<totalnum;i++){
						
						var reasonlevel=selectreasongridds.getAt(rowIndex+1).get("reasonlevel") ;
						if (reasonlevel!="") selectreasongridds.removeAt( rowIndex+1 ); 
		
					}
			         selectreasongridds.remove( selectedRow ); 
			} 
	
	
			
			
	    });   
	


	///提交原因
	
	function SaveReason()
	{
        var chkexistflag=0;
        var reasonlevstr=""
        var reasondrstr="";
        var totalnum =selectreasongrid.getStore().getCount() ;
	
        var levelflag=0;
		for(var i=0;i<totalnum;i++){
		      
		        var reasondr=selectreasongridds.getAt(i).get("reasonrowid") ;
	  	        var reasonlevel=selectreasongridds.getAt(i).get("reasonlevel") ; 
	  	         
	  	        ///组织字符串 ：原因ID1^原因ID2 $$$ 药品ID1 $$$ 药品ID2 ! 原因ID3^ ...     	  		
		        if (reasonlevel!=""){
		                
		        	reasondrstr=reasondrstr+"$$$"+reasondr ;
		        	levelflag=1;
		        	chkexistflag=1;
		        	
		        }
		        else
		        {
		                if (reasondrstr=="")
		                	{
		  		     			 reasondrstr=reasondr ;
		  					}else
		  					{
		  						if (levelflag==1){
		  						   reasondrstr=reasondrstr+"!"+reasondr ;
		  						   levelflag=0;
		  						}
		  						else
		  						{
		  						   reasondrstr=reasondrstr+"^"+reasondr ;
		  							
		  						}
		  							
		  					}
		  					
		        }
		        

		  		
		  	
		}
		
		if (chkexistflag==0){
			     	
			     	Ext.Msg.show({title:'提示',msg:'请在问题列表中加入相关联的医嘱,然后再重试！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	                return;
		}

		//var facrowid=Ext.getCmp("ReasonFactorCom").getValue(); //警示值
		//var advrowid=Ext.getCmp("PhAdviceCom").getValue(); //建议	
		//var phnote=Ext.getCmp("PhAdviceArea").getValue();  //备注
		
		
		var ret=reasondrstr+"@"  //+facrowid+"@"+advrowid+"@"+phnote ;
		
		
		window.returnValue=ret;
	        window.close();  
	
	
	}



	///添加药品列表
	
	function DrugSelectEvent(tmpincistr,tmpincidescstr)
	{             
	                   
	                if (tmpincistr=="") {
	                    return;
	                }
	                var reasonlevel="" ; //药品上级level
	                var insertrow="" ;   //药品插入行
	                if(selectreasongrid.getStore().getCount()==0){
	                	
	                	Ext.Msg.show({title:'提示',msg:'请先双击选择不合理原因,然后再重试！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	                
	                	return;
	                }
	                
	                
	                var row = Ext.getCmp("selreagrid").getSelectionModel().getSelections(); 	
		            if (row.length == 0) {  
			      		insertrow=selectreasongrid.getStore().getCount() ;
			      		var reasonlevel=selectreasongridds.getAt(insertrow-1).get("reasonrowid") ;	  
		        	}else{
		              	var reasonlevel = row[0].data.reasonrowid;
		       		}
	                	               
	                var inciarr=tmpincistr.split(",");
	                var incidescarr=tmpincidescstr.split(",");
	                var arrcnt=inciarr.length ;
	                for (var l=0;l<arrcnt;l++){
	                    var retflag=0;  
	                	inci=inciarr[l];
	                	incidesc="____"+incidescarr[l];
                          
		            	var totalnum =selectreasongrid.getStore().getCount() ;
						for(var i=0;i<totalnum;i++){		      
				        	var reasondr=selectreasongridds.getAt(i).get("reasonrowid") ;	  	        
			  				if (reasondr==inci){	  		     
			  		    	retflag=1;      //重复药品不能添加 
			  			}
			  			if (reasondr==reasonlevel){
			  		   		insertrow=i+1;   //药品插入行
			  			}			  		
			  		
					}
					if  (retflag==1) continue;
		                var newselreagridds = selectreasongrid.getStore().recordType;
		                var p = new newselreagridds({
		                    reasondesc: incidesc,
		                    reasonrowid: inci,
		                    reasonlevel:reasonlevel
		                });
		                selectreasongrid.stopEditing();
		                selectreasongridds.insert(insertrow, p);
		                //selectreasongrid.startEditing(0, 0);
	                
	                
	                }
	                
	                
	}



});
