function InitDMReportNo()
{
    var obj=new Object();
    obj.cboLoc=new Common_ComboToLoc("cboLoc","分配科室");
	
	obj.btnPass=new Ext.Button({
        id:'btnPass'
        ,text:'手工分号'
        ,iconCls:'icon-update'
    });
    obj.ConditionPanel=new Ext.Panel({
        id:'ConditionPanel'
        ,layout:'column'
        ,title:''
        ,items:[
            {
				layout:'form'
				,width:240
				,labelAlign:'right'
				,labelWidth:70
				,items:[obj.cboLoc]
            },{
				width : 10
			},{
				layout:'form'
				,width:85
				,items:[obj.btnPass]
			}
        ]
    });
	
    obj.gridRepNoListProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
        url:ExtToolSetting.RunQueryPageURL
    }));
    obj.gridRepNoListStore=new Ext.data.Store({
            proxy:obj.gridRepNoListProxy
            ,reader:new Ext.data.JsonReader(
                {
                     root:'record'
                    ,total:'property'
                    ,idProperty:'RowId'
                }
               ,[
                  ,{name:'RowId',mapping:'RowId'}
                  ,{name:'Type',mapping:'Type'}
                  ,{name:'ReportNo',mapping:'ReportNo'}
                  ,{name:'Loc',mapping:'Loc'}
                  ,{name:'Doctor',mapping:'Doctor'}
                  ,{name:'Status',mapping:'Status'}
                  ,{name:'IsActive',mapping:'IsActive'}
                  ,{name:'Resume',mapping:'Resume'}
                  ,{name:'storaDate',mapping:'storaDate'}
                  ,{name:'storaTime',mapping:'storaTime'}
                  ,{name:'StoraUser',mapping:'StoraUser'}
                ])
    });
    obj.gridRepNoList=new Ext.grid.GridPanel({
        id:'gridRepNoList'
        ,region:'center'
        ,height:572
        ,store:obj.gridRepNoListStore
        ,columns:[
            new Ext.grid.RowNumberer()
            ,{header:'死亡证明书编号',dataIndex:'ReportNo',sortable:true,width:160, menuDisabled:true, align: 'center'}
            ,{header:'分配科室',dataIndex:'Loc',sortable:true,width:150, menuDisabled:true, align: 'left'}
			,{header:'操作人',dataIndex:'StoraUser',sortable:true,width:60, menuDisabled:true, align: 'center'}
            ,{header:'操作日期',dataIndex:'storaDate',sortable:true,width:80, menuDisabled:true, align: 'center'}
            ,{header:'操作时间',dataIndex:'storaTime',sortable:true,width:70, menuDisabled:true, align: 'center'}
		]
		,bbar:new Ext.PagingToolbar({
			 pageSize:18
			,store:obj.gridRepNoListStore
			,displayMsg:'显示记录：{0}-{1} 合计：{2}'
			,displayInfo:false
			,emptyMsg:'没有记录'
		})
    });
	
    obj.VpDMRNoList=new Ext.Viewport({
        id:'VpDMRNoList'
       ,layout:'border'
       ,items:[
			{
				region: 'north',
				height: 40,
				layout : 'form',
				frame : true,
				items:[
					obj.ConditionPanel
				]
			}
		    ,obj.gridRepNoList
       ]
    });
	
    obj.gridRepNoListProxy.on('beforeload',function(gridRepNoListProxy,param){
		param.ClassName = 'DHCMed.DTHService.RepNoSrv';
		param.QueryName = 'QryRepNobyLocID' ;
		param.Arg1=obj.cboLoc.getValue();
		param.ArgCnt=1;
	});
	
    InitDMReportNoEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_3=String.fromCharCode(3);