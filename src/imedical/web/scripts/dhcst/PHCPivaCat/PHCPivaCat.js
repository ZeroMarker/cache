// /名称: 		药品配液分类维护
// /描述: 		药品配液分类维护
// /编写者：	hulihua
// /编写日期: 	2016.12.15
function addNewRow(){
	var record=Ext.data.Record.create([
	    {
		    name:'RowId',
		    type:'int'
		},{
			name:'Code',
			type:'string'
		},{
			name:'Desc',
			type:'string'
		}
	]);
	var NewRecord=new record({
		RowId:'',
		Code:'',
		Desc:''
		});
	PHCPivaCatGriDs.add(NewRecord);
	PHCPivaCatGrid.startEditing(PHCPivaCatGriDs.getCount()-1,1)
	}
var PHCPivaCatGrid=""
//配置数据源
var PHCPivaCatGridUrl='dhcst.phcpivacataction.csp';
var PHCPivaCatGridProxy=new Ext.data.HttpProxy({url:PHCPivaCatGridUrl+'?actiontype=query',method:'GET'});
var PHCPivaCatGriDs=new Ext.data.Store({
	proxy:PHCPivaCatGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results',
		pagesize:35
	},[
	    {name:'RowId'},
	    {name:'Code'},
	    {name:'Desc'}
	]),
	remoteSort:true,
	pruneModifiedRecords:true
	})
//模型
var PHCPivaCatGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"代码",
        dataIndex:'Code',
        width:180,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'codeField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						PHCPivaCatGrid.startEditing(PHCPivaCatGriDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
        header:"名称",
        dataIndex:'Desc',
        width:300,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewRow();
					}
				}
			}
        })
    }
]);
//初始化默认排序功能
PHCPivaCatGridCm.defaultSortable = true;
var addPHCPivaCat=new Ext.Toolbar.Button({
	text:'新建',
	tooltip:'新建',
	iconCls:'page_add',
	width:70,
	height:30,
	handler:function(){
		addNewRow()
		}
	})
var savePHCPivaCat=new Ext.Toolbar.Button({
	text:'保存',
	tooltip:'保存',
	iconCls:'page_save',
	width:70,
	height:30,
	handler:function(){
		//获取所有的新记录 
		var mr=PHCPivaCatGriDs.getModifiedRecords();
		var data="";
		for (i=0;i<mr.length;i++){
			var code=mr[i].data["Code"].trim();
			var desc=mr[i].data["Desc"].trim();
			var rowNum = PHCPivaCatGriDs.indexOf(mr[i])+1;
			if (code==""){
				Msg.info("warning", "第"+rowNum+"行代码为空!");
				return;
			}
			if (desc==""){
				Msg.info("warning", "第"+rowNum+"行名称为空!");
				return;
			}
			if((code!="")&&(desc!="")){
				var dataRow=mr[i].data["RowId"]+"^"+code+"^"+desc
				if(data==""){
					data=dataRow}
				else{
					data=data+xRowDelim()+dataRow   
					}	 
				}
			}
			
		if(data==""){
			Msg.info("warning","没有修改或添加新数据!");
			return false;
			}else{
				var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
				Ext.Ajax.request({
					url:PHCPivaCatGridUrl+'?actiontype=save',
					params:{data:data},
					failure:function(result,request){
						mask.hide();
						Msg.info("error","请检查网络连接!")
						},
					success:function(result,request){
						var jsonData=Ext.util.JSON.decode(result.responseText);
						mask.hide();
						if(jsonData.success=='true'){
							Msg.info("success","保存成功!");
							PHCPivaCatGriDs.load()
						}else{
							if(jsonData.info==-1){
								Msg.info("warning","此代码已经维护!");
								}else if(jsonData.info==-2){
									Msg.info("warning","此名称已经维护!");
									}else{
							Msg.info("error","保存失败!");
									}
							PHCPivaCatGriDs.load()
							}
							
						},	
					scope:this
					});
				}	
			
			
		}
	})

var deletePHCPivaCat=new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'page_delete',
	width:70,
	height:30,
	handler:function(){
		deleteDetail();
		}
	})
//删除函数	
function deleteDetail(){
	var cell=PHCPivaCatGrid.getSelectionModel().getSelectedCell();
	if (cell==null){
		Msg.info("error","请选择数据!");
		return false;
		}else{
			var record=PHCPivaCatGrid.getStore().getAt(cell[0]);
			var RowId=record.get("RowId")
			if (RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn){
					if(btn=="yes"){
						var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:PHCPivaCatGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error", "请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success", "删除成功!");
										PHCPivaCatGriDs.load()
									}else{
										Msg.info("error", "删除失败!");
									}
								},
								scope: this
							});
						}
					}
				)
				
				}else{
					var rowInd=cell[0];
					if(rowInd>=0){
						PHCPivaCatGrid.getStore().removeAt(rowInd)
						}
					}
				
				
			}
		}		
//表格
PHCPivaCatGrid=new Ext.grid.EditorGridPanel({
	store:PHCPivaCatGriDs,
	cm:PHCPivaCatGridCm,
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMast:true,
	tbar:[addPHCPivaCat,'-',savePHCPivaCat],//,'-',deletePHCPivaCat],
	clicksToEdit:1
	})
PHCPivaCatGriDs.load()
//===========模块主页面===============================================
Ext.onReady(function(){
Ext.QuickTips.init();
Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			height : 30,
			labelAlign : 'right',
			title:'药品配液分类维护',
			region: 'center',
			frame : true,
			autoHeight:true,
			//autoScroll : true,
			bodyStyle : 'padding:10px 10px 10px 10px;'
			
		});
// 5.2.页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [  HisListTab,
				        {
			                 region: 'center',						                
					   title: '药品配液分类',
					   layout: 'fit', // specify layout manager for items
					   items: PHCPivaCatGrid  			               
			               }
	       			],
					renderTo : 'mainPanel'
				})
	
})

//===========模块主页面===============================================