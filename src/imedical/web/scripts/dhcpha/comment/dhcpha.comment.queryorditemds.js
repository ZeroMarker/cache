var unitsUrl = 'dhcpha.comment.queryorditemds.save.csp';

Ext.onReady(function() {

	    Ext.QuickTips.init();// 浮动信息提示	
        Ext.Ajax.timeout = 900000;
        Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;


        var Request = new Object();
        Request = GetRequest();
        var adm = Request['EpisodeID'];
        
        
                 ///类型 
        var PriortyData=[['长期医嘱','1'],['临时医嘱','2']];
	 
	 
	var PriortyStore = new Ext.data.SimpleStore({
		fields: ['desc', 'id'],
		data : PriortyData
		});

	var PriortyCombo = new Ext.form.ComboBox({
		store: PriortyStore,
		displayField:'desc',
		mode: 'local', 
		width : 120,
		id:'PriortyCmb',
		emptyText:'',
		valueField : 'id',
		emptyText:'医嘱优先级...',
		fieldLabel: '医嘱优先级'
	});  
	
	
	

	
        
    ///医嘱明细数据table
    

  var orddetailgridcm = new Ext.grid.ColumnModel({
  
  columns:[
        {header:'医嘱开单日期',dataIndex:'orddate',width:120},
        {header:'药品名称',dataIndex:'incidesc',width:250},
        {header:'数量',dataIndex:'qty',width:40},
        {header:'单位',dataIndex:'uomdesc',width:60},
        {header:'剂量',dataIndex:'dosage',width:60},
        {header:'频次',dataIndex:'freq',width:40},
        {header:'规格',dataIndex:'spec',width:80},
        {header:'用法',dataIndex:'instruc',width:80},
        {header:'优先级',dataIndex:'pri',width:80},
        {header:'用药疗程',dataIndex:'dura',width:60},
        {header:'处方号',dataIndex:'presc',width:90},
        {header:'剂型',dataIndex:'form',width:90},
        {header:'基本药物',dataIndex:'basflag',width:60},
        {header:'医生',dataIndex:'doctor',width:60},
        {header:'医嘱备注',dataIndex:'remark',width:90},
        {header:'医嘱状态',dataIndex:'ordstatus',width:90}
            
          ]   
            
    
    });
 
 
    var orddetailgridds = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({
			url : unitsUrl+ '?action=GetOrdItmDsByAdm&adm='+adm,

			method : 'POST'
		}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'incidesc',
            'qty',
	    'uomdesc',
	    'dosage',
	    'freq',
	    'spec',
	    'instruc',
	    'dura',
	    'presc',
	    'form',
	    'basflag',
	    'doctor',
	    'orddate',
	    'remark',
	    'pri',
	    'ordstatus'
	    
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
        margins:'0 0 0 0',
        stripeRows: true,
        autoScroll:true,
	title:"本次医嘱",
        enableHdMenu : false,
        ds: orddetailgridds,
        cm: orddetailgridcm,
        enableColumnMove : false,
	tbar:['医嘱优先级',PriortyCombo],  
        bbar: orddetailgridcmPagingToolbar,
        trackMouseOver:'true'
        

        
    });
       
 	orddetailgridds.load({
		params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize,pri:'',findflag:1},
		callback: function(r, options, success){
   
	    
		           
		          }
		
	});

	PriortyCombo.on(
		"select",
		function(cmb,rec,id ){
		
		        var prival=cmb.getValue();
		 
		      	orddetailgridds.load({
				params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize,pri:prival,findflag:1},
				callback: function(r, options, success){
		   
			    
				           
				          }
				
			});
		}
	);
	
	
	
	var centerpanel = new Ext.Panel({
        region: 'center',        //指定在东部
        width: 400,
        layout:'fit',
        items : [orddetailgrid]
      });
        ///view

	var por = new Ext.Viewport({

				layout : 'border', // 使用border布局
                              
				items : [centerpanel]

			});





	


});
