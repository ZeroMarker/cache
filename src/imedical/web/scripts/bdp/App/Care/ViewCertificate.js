/// 名称: 查看毒麻处方权证书
/// 编写者： 基础数据平台组 、蔡昊哲
/// 编写日期: 2013-9-12
	
	var CommonJS = '../scripts/bdp/Framework/scripts/Common.js';    //证书上传部分
	document.write('<scr' + 'ipt type="text/javascript" src="'+CommonJS+'"></scr' + 'ipt>');
	
Ext.onReady(function() {

    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	SignSrc = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	//医护人员维护
	var SAVE_ACTION_CareProv = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassMethod=SaveData&pEntityName=web.Entity.CT.CTCareProv";   //保存到医护人员表中
   	var ACTION_CareProv = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassQuery=GetList"; 
	var BindingCarPrvTp = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCarPrvTp&pClassQuery=GetList";
	
    var UploadPic="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassMethod=UploadPic";	
    
	pagesize=20;
    
    Ext.QuickTips.init();												   //--------启用悬浮提示

	/**---------------------权限判断 (session['LOGON.GROUPDESC']="Demo Group")  ------------------**/
    var InternalType;
    InternalType="demo";
    
    /**---------------------权限判断-------------------**/
	
var CTPCPHICApprovedButton = new Ext.Toolbar.Button({         //----------CTPCPAnaesthetist  毒麻处方权
		text:'查看证书',
        //fieldLabel: '查看证书',
		iconCls : 'icon-search',
        name: 'CTPCPHICApprovedButton',
        id: 'CTPCPHICApprovedButton',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPHICApprovedButton'),
		handler: function ShowPic() {
		if(grid.selModel.hasSelection()){
			var _record = grid.getSelectionModel().getSelected();//records[0]		
			win_uploadImage.setTitle("毒麻处方权资格证书-" + _record.get('CTPCPDesc')+ "_" + _record.get('CTPCPCode'));  
    		win_uploadImage.imageIndexName = 'Pic1'; 
    		win_uploadImage.show();
    		var CareID = _record.get("CTPCPCode")+"mf";
    		ShowPicByPatientID(CareID,'imageBrowse');
    		
    		Ext.getCmp("HidenPicRowId1").reset();
            Ext.getCmp("HidenPicRowId1").setValue(CareID);
		}
        else
		{
		Ext.Msg.show({
					title:'提示',
					msg:'请选择需要查看的人员!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
		}
		}
    });
    
    //上传图片类型
var img_reg = /\.([jJ][pP][gG]){1}$|\.([jJ][pP][eE][gG]){1}$|\.([gG][iI][fF]){1}$|\.([pP][nN][gG]){1}$|\.([bB][mM][pP]){1}$/;


var HidenPicRowId1 = new Ext.form.TextField({ 
    fieldLabel: 'HidenPicRowId1',
	hideLabel:'True',
	hidden : true,
	id: 'HidenPicRowId1',
	name: 'HidenPicRowId1'
});

var win_uploadImage = new Ext.Window({
	layout:'fit',
	width:620,
	closeAction:'hide',
	height:370,
	resizable:false,
	shadow:false,
	modal:true,
	closable:true,
	bodyStyle:'padding: 5 5 5 5',
	animCollapse:true,
	imageIndexName:'',
	items:[{
		xtype:'form',
		id:'image-upload-form',
		frame:true,
		border:false,
		isAdd:false,
		enctype: 'multipart/form-data',
		fileUpload : true,
		layout : 'form',
		items:[HidenPicRowId1,
		{
		  xtype: 'panel',
		  id : 'imageBrowse',
		  html : "<p style='text-align:center'><img src='ftp://10.160.16.112:21/CarePhoto/blank.gif' width=420 height=210></p>"
		}
		], 
		buttons:[{
	       text:'关闭',
	       handler:function(){
				win_uploadImage.hide();
	       }
	    }
	   ]
}]
});
    
    
	var sm = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
	var dscareprov = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_CareProv}),//调用的动作
        reader: new Ext.data.JsonReader({
            	totalProperty: 'total',
            	root: 'data',
            	successProperty :'success'
        	},
		   [{ name: 'CTPCPRowId1', mapping:'CTPCPRowId1',type: 'string'},
			{ name: 'CTPCPCode', mapping:'CTPCPCode',type: 'string'},					
			{ name: 'CTPCPDesc', mapping:'CTPCPDesc',type: 'string'},
			{ name: 'CTPCPHICApproved',mapping:'CTPCPHICApproved', type: 'string'}//列的映射
			]),
		remoteSort: true
    });
    
  	  dscareprov.load({
			params:{start:0, limit:20},
			callback: function(records, options, success){
			}
		});
	var pagingcareprov= new Ext.PagingToolbar({
            pageSize: 20,
            store: dscareprov,
            displayInfo: true,
			//plugins: new Ext.ux.ProgressBarPager()
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
			//plugins: new Ext.ux.ProgressBarPager()，
            emptyMsg: "没有记录"
        })
    
    var tbbutton=new Ext.Toolbar({
		enableOverflow: true,
		items:[CTPCPHICApprovedButton
		//,'-',btnAccredit,'-',btnSpec,'-',btnCarPrvTp
		]//,'->',{text:'刷新',iconCls:'icon-arrowrefresh'}
	});
	var btnSearch=new Ext.Button({
        id:'btnSearch',
        iconCls:'icon-search',
        text:'搜索',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
        handler:function(){
	    	grid.getStore().baseParams={
				Code:Ext.getCmp("CareID").getValue(),
				Desc:Ext.getCmp("CareName").getValue(),
				CTPCPCarPrvTpDR:Ext.getCmp("CarePrvTp").getValue(),
				CTPCPHICApprovedFlag:Ext.getCmp("CTPCPHICApprovedFlag").getValue()				
			};
		    grid.getStore().load({params:{start:0, limit:pagesize}});
        }

    });
		
	//刷新工作条
	var btnRefresh = new Ext.Button({
        id:'btnRefresh',
        iconCls:'icon-refresh',
        text:'重置',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
        handler:function Refresh(){
			Ext.getCmp("CareID").reset();
			Ext.getCmp("CareName").reset();
			Ext.getCmp("CarePrvTp").reset();
			Ext.getCmp("CTPCPHICApprovedFlag").reset();
			grid.getStore().baseParams={			
				Code :  Ext.getCmp("CareID").getValue(),
				Desc : Ext.getCmp("CareName").getValue(),
				CTPCPCarPrvTpDR : Ext.getCmp("CarePrvTp").getValue(),
				CTPCPHICApprovedFlag : Ext.getCmp("CTPCPHICApprovedFlag").getValue()
		    };
			grid.getStore().load({params:{start:0, limit:pagesize}});
		//}
        }

    });
				
    var careprovtype = new Ext.form.ComboBox({
    	width:150,
		fieldLabel: '医护人员类型',
		id:'careprovtype',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('careprovtype'),
		xtype:'combo',
		id:'CarePrvTp',
		triggerAction:'all',//query
		forceSelection: true,
		selectOnFocus:false,
		typeAhead:true,
		mode:'remote',
		pageSize:10,
		minChars: 0,
		listWidth:250,
		valueField:'CTCPTRowId',
		displayField:'CTCPTDesc',
		store:new Ext.data.JsonStore({
			url:BindingCarPrvTp,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'CTCPTRowId',
			fields:['CTCPTRowId','CTCPTDesc'],
			remoteSort: true,
			sortInfo: {field: 'CTCPTRowId', direction: 'ASC'}	
		}),
		listeners:{
			//传值之前时就把查询条件赋值给它
	        'loadbefore': function(field, e){
	        	careprovtype.getStore().baseParams={
	        		InternalType : "DOCTOR"
        		};
	        }
		}
	});
        
	var CTPCPHICApprovedFlag= new Ext.form.ComboBox({
		fieldLabel: '毒麻处方权',
		xtype:'combo',
		id:'CTPCPHICApprovedFlag',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPHICApprovedFlag'),
		width:100,
		mode:'local',
		hiddenName:'hxxx',//不能与id相同
		triggerAction:'all',//query
		forceSelection: true,
		selectOnFocus:false,
		typeAhead:true,
		minChars: 1,
		listWidth:100,
		valueField:'value',
		displayField:'name',
		store: new Ext.data.JsonStore({
	        fields : ['name', 'value'],
	        data   : [
	            {name : 'Yes',   value: 'Y'},
	            {name : 'No',  value: 'N'}
	        ]
	    })

	});
	//工具栏
    var tb= new Ext.Toolbar({
        id:'tb',
        items:[
            '工号:',
            {
				xtype: 'textfield',
				width: 100,
				id: 'CareID',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CareID')
			},
            '-',
            '姓名:',
            {
				xtype: 'textfield',
				width: 100,
				id: 'CareName',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CareName')
			},
            //'-',
            //'医护人员类型:',
            //careprovtype,
            '-',
            '毒麻处方权:',
            CTPCPHICApprovedFlag,
            '-',
            btnSearch,
			'-',
			btnRefresh,
            '->'
            //btnHelp
        ],
		listeners:{
        render:function(){
        tbbutton.render(grid.tbar)  //tbar.render(panel.bbar)这个效果在底部
        }
    }
	});
	
	var grid = new Ext.grid.GridPanel({
		id:'grid',
		region: 'center',
		closable:true,
		store: dscareprov,
		align:'center',
		trackMouseOver: true,
		//clicksToEdit: 1,
		columns: [
		    sm,
		    { header: 'CTPCPRowId1', sortable: true, dataIndex: 'CTPCPRowId1',hidden:true },
		    { header: '工号',sortable: true, dataIndex: 'CTPCPCode',width : 60},
		    { header: '姓名',sortable: true, dataIndex: 'CTPCPDesc',width : 80 },
		    { header: '毒麻处方权',sortable: true, dataIndex: 'CTPCPHICApproved',renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon}
		],
	    stripeRows: true,
	    loadMask: { msg: '数据加载中,请稍候...' },
	    title: '医护人员维护',
	    stateful: true,
	    tools:Ext.BDP.FunLib.Component.HelpMsg,
	    viewConfig: {forceFit: true},
		bbar:pagingcareprov,
		tbar:tb,
	    stateId: 'grid'
	});
	
	grid.on("rowdblclick",function(grid,rowIndex,e){
		if(grid.selModel.hasSelection()){
			var _record = grid.getSelectionModel().getSelected();//records[0]		
			win_uploadImage.setTitle("毒麻处方权资格证书-" + _record.get('CTPCPDesc')+ "_" + _record.get('CTPCPCode'));  
    		win_uploadImage.imageIndexName = 'Pic1'; 
    		win_uploadImage.show();
    		var CareID = _record.get("CTPCPCode") +"mf";
    		ShowPicByPatientID(CareID,'imageBrowse'); 		
    		Ext.getCmp("HidenPicRowId1").reset();
            Ext.getCmp("HidenPicRowId1").setValue(CareID);
		}
        else
		{
		Ext.Msg.show({
					title:'提示',
					msg:'请选择需要查看的人员!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
		}
	});		

	
	/**---------------------右键菜单-------------------**/	
    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [grid]
    });
});
