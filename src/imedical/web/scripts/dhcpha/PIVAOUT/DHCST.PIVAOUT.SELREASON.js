
var unitsUrl = 'DHCST.PIVAOUT.SAVEURL.csp';


Ext.onReady(function() {

	Ext.QuickTips.init();// ������Ϣ��ʾ
	
        var Request = new Object();
        Request = GetRequest();
        var orditmstr = Request['orditmstr'];
        var waycode = Request['waycode'];

        var BedButton = new Ext.Button({
             width : 65,
             id:"ComBedBtn",
             text: '����',
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
        



	// ����һ����д

	var Tree = Ext.tree;

	// ������ڵ��Loader

	var treeloader = new Tree.TreeLoader({

				dataUrl : unitsUrl + '?action=ListTreeData'

			});

	// ���һ���������

	var treepanel = new Tree.TreePanel({

				//el : 'tree-panel',// 

				region : 'west',

				title : '��һ��:ѡ�񲻺ϸ�ԭ��',

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
				
				tbar:['��ʾ: ˫ �� �� ��']

			});

	// �첽���ظ��ڵ�

	var rootnode = new Tree.AsyncTreeNode({

				text : 'root',

				id : 'id',

				value : '0',

				level : '0',

				draggable : false , // ���ڵ㲻�����϶�

				expanded : true

			});

	// Ϊtree���ø��ڵ�

	treepanel.setRootNode(rootnode);

	// ��Ӧ����ǰ�¼�������node����

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

	// �������ĵ���¼�

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

	// ������굥���¼�

	treepanel.on('dblclick', treeClick);
	

	
   
   
   //Center
  var orditmgridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'ҽ������',dataIndex:'DrugDesc',width:300},
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
   
 	    title:'�ڶ���:ѡ��ԭ���������ҽ��',
 	    tbar:['��ʾ: ˫ �� �� ��'],
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
       
        {header:'����',dataIndex:'reasondesc',width:300},
        {header:'rowid',dataIndex:'reasonrowid',width:40},
        {header:'�ּ�',dataIndex:'reasonlevel',width:40}  
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
 
	    tbar:['��ʾ: ˫ �� ȡ ��','-',BedButton],
        trackMouseOver:'true'
        

        
    });
    

              	  
 

	var eastPanel = new Ext.Panel({
        region: 'east',        //ָ���ڶ���
        title: '������:����,���������б�',
        width: 400,
        margins:'0 0 0 0',
        items : [selectreasongrid]
      });
        ///view

	var por = new Ext.Viewport({

				layout : 'border', // ʹ��border����

				items : [treepanel,orditmgrid,eastPanel]

			});





        ///-----------------------Events----------------------

	//ѡ�����¼�
	function TreeNodeClickEvent(nodeid,nodedesc)
	{               
	                if (nodeid==0){
	                 return;
	                }
	                var totalnum =selectreasongrid.getStore().getCount() ;
			for(var i=0;i<totalnum;i++){		      
			        var reasondr=selectreasongridds.getAt(i).get("reasonrowid") ;	  	        
		  		if (reasondr==nodeid){	  		     
		  		     Ext.Msg.show({title:'��ʾ',msg:'�Ѵ���,�����ظ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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


	///˫��gridȥ��ԭ���¼�   
	 
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
	


	///�ύԭ��
	
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
	  	         
	  	        ///��֯�ַ��� ��ԭ��ID1^ԭ��ID2 $$$ ҩƷID1 $$$ ҩƷID2 ! ԭ��ID3^ ...     	  		
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
			     	
			     	Ext.Msg.show({title:'��ʾ',msg:'���������б��м����������ҽ��,Ȼ�������ԣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	                return;
		}

		//var facrowid=Ext.getCmp("ReasonFactorCom").getValue(); //��ʾֵ
		//var advrowid=Ext.getCmp("PhAdviceCom").getValue(); //����	
		//var phnote=Ext.getCmp("PhAdviceArea").getValue();  //��ע
		
		
		var ret=reasondrstr+"@"  //+facrowid+"@"+advrowid+"@"+phnote ;
		
		
		window.returnValue=ret;
	        window.close();  
	
	
	}



	///���ҩƷ�б�
	
	function DrugSelectEvent(tmpincistr,tmpincidescstr)
	{             
	                   
	                if (tmpincistr=="") {
	                    return;
	                }
	                var reasonlevel="" ; //ҩƷ�ϼ�level
	                var insertrow="" ;   //ҩƷ������
	                if(selectreasongrid.getStore().getCount()==0){
	                	
	                	Ext.Msg.show({title:'��ʾ',msg:'����˫��ѡ�񲻺���ԭ��,Ȼ�������ԣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	                
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
			  		    	retflag=1;      //�ظ�ҩƷ������� 
			  			}
			  			if (reasondr==reasonlevel){
			  		   		insertrow=i+1;   //ҩƷ������
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
