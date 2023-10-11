///////////////////////////////////////////////////
var tmpData="";

var itemGridUrl = '../csp/herp.srm.srmuserexe.csp';
//配件数据源
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, ['SRowid',
			'rowid',
			'Code',
			'Name',
			'Type',
			'Sex',
			'BirthDay',
			'IDNum',
			'TitleDr',
			'Phone',
			'EMail',
			'Degree',
			'Compdr',
			'Monographnum',
			'Papernum',
			'Patentnum',
			'InvincustomstanNum',
			'Trainnum',
			'Holdtrainnum',
			'InTrainingNum',
			'IsValid',
			'JobType',
			'IsTeacher',
			'IsExpert',
			'EthicalExperts'
		]),
	    remoteSort: true
});

Ext.ns("dhc.herp");

dhc.herp.PageSizePlugin = function() {
	dhc.herp.PageSizePlugin.superclass.constructor.call(this, {
				store : new Ext.data.SimpleStore({
							fields : ['text', 'value'],
							data : [['10', 10], ['20', 20], ['30', 30],
									['50', 50], ['100', 100]]
						}),
				mode : 'local',
				displayField : 'text',
				valueField : 'value',
				editable : false,
				allowBlank : false,
				triggerAction : 'all',
				width : 40
			});
};

Ext.extend(dhc.herp.PageSizePlugin, Ext.form.ComboBox, {
			init : function(paging) {
				paging.on('render', this.onInitView, this);
			},

			onInitView : function(paging) {
				paging.add('-', this, '-');
				this.setValue(paging.pageSize);
				this.on('select', this.onPageSizeChanged, paging);
			},

			onPageSizeChanged : function(combo) {
				this.pageSize = parseInt(combo.getValue());
				this.doLoad(0);
			}
		});
		
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 25,
		store: itemGridDs,
		plugins : new dhc.herp.PageSizePlugin(),
		atLoad : true,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"//,

});
//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('Name', 'desc');


//查询科室名称
var uCodeField = new Ext.form.TextField({
	id: 'uCodeField',
	fieldLabel: '用户编码',
	width:100,
	listWidth : 245,
	triggerAction: 'all',
	//emptyText:'',
	name: 'uCodeField',
	minChars: 1,
	pageSize: 10,
	editable:true
});
var uNameField = new Ext.form.TextField({
	id: 'uNameField',
	fieldLabel: '用户名称',
	width:100,
	listWidth : 245,
	triggerAction: 'all',
	//emptyText:'',
	name: 'uNameField',
	minChars: 1,
	pageSize: 10,
	editable:true
});

var uTypeDsGrid = new Ext.data.SimpleStore({
	fields : ['key', 'keyValue'],
	data : [['1', '本院职工'], ['2', '研究生'], ['3', '院外人员']]
});
var uTypeGridField = new Ext.form.ComboBox({
    id : 'uTypeGridField',
	fieldLabel : '用户类型',
	width : 100,
	listWidth : 100,
	store : uTypeDsGrid,
	valueNotFoundText : '',
	displayField : 'keyValue',
	valueField : 'key',
	mode : 'local', // 本地模式
	triggerAction: 'all',
	//emptyText:'请选择...',
	selectOnFocus:true,
	forceSelection : true
});	

var findButton = new Ext.Toolbar.Button({
    text: '查询',       
    iconCls:'search',
	handler:function(){	
	    var code = uCodeField.getValue();
		var name = uNameField.getValue();
        var type = uTypeGridField.getValue();
	    itemGridDs.proxy = new Ext.data.HttpProxy({
	    	url : itemGridUrl+'?action=list&code='+ encodeURIComponent(code)+ 
				'&name='+encodeURIComponent(name)+
				'&type='+ encodeURIComponent(type),
			method : 'GET'});
		itemGridDs.load({params : {start : 0,limit : 25,sortDir:'',sortField:''}});
	}
});
/* var tmpTitle='科研人员维护';	
var combos = new Ext.FormPanel({
			height:50,
			region:'north',
			frame:true,
			defaults: {bodyStyle:'padding:5px'},
				items:[{
			    columnWidth:1,
			    xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype:'displayfield',
						value:'用户编码:',
						columnWidth:60
					},
					uCodeField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},{
						xtype:'displayfield',
						value:'用户名称:',
						columnWidth:60
					},
					uNameField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},
					{
						xtype:'displayfield',
						value:'用户类型:',
						columnWidth:.09
					},
					uTypeGridField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},{
						columnWidth:0.1,
						xtype:'button',
						text: '查询',
						handler:function(b){
							srmdeptuserDs();
						},
						iconCls: 'add'
					}	
		     	]
			}]
});	 */


//数据库数据模型
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
        {

            id:'rowid',
            header: '用户ID',
            allowBlank: false,
            width:120,
            editable:false,
			//sortable:true,
            hidden:true,
            dataIndex: 'rowid'
       }, {

            id:'SRowid',
            header: '单位依赖ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'SRowid'
       }, {
            id:'Code',
            header: '用户编号',
            allowBlank: false,
            width:100,
			//sortable:true,
            editable:false,
            dataIndex: 'Code'
       }, {
            id:'Name',
            header: '用户名称',
            allowBlank: false,
            width:100,
            editable:false,
			//sortable:true,
            dataIndex: 'Name'
       }, {
            id:'JobType',
            header: '岗位性质',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'JobType'
       },{
            id:'Type',
            header: '用户类型',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Type'
       }, {
    	     id:'Sex',
    	     header: '性别',
    	     allowBlank: false,
    	     width:80,
    	     editable:false,
    	     dataIndex: 'Sex'
    	}, {
    	     id:'BirthDay',
    	     header: '出生日期',
    	     allowBlank: false,
    	     width:100,
    	     editable:false,
    	     dataIndex: 'BirthDay'
    	}, {
    	     id:'IDNum',
    	     header: '身份证号',
    	     allowBlank: false,
    	     width:180,
    	     editable:false,
    	     dataIndex: 'IDNum'
    	}, {
    	     id:'TitleDr',
    	     header: '技术职称',
    	     allowBlank: false,
    	     width:100,
    	     editable:false,
    	     dataIndex: 'TitleDr'
    	}, {
    	     id:'Phone',
    	     header: '联系电话 ',
    	     allowBlank: false,
    	     width:100,
    	     editable:false,
    	     dataIndex: 'Phone'
    	}, {
    	     id:'EMail',
    	     header: '邮箱地址',
    	     allowBlank: false,
    	     width:180,
    	     editable:false,
    	     dataIndex: 'EMail'
    	}, {
    	     id:'Degree',
    	     header: '学位',
    	     allowBlank: false,
    	     width:120,
    	     editable:false,
    	     dataIndex: 'Degree'
    	}, {
    	     id:'Compdr',
    	     header: '科研用户依托单位',
    	     allowBlank: false,
    	     width:180,
    	     editable:false,
    	     dataIndex: 'Compdr'
    	}, {
    	     id:'IsTeacher',
    	     header: '是否有教师资格证',
    	     allowBlank: false,
    	     width:100,
    	     editable:false,
    	     dataIndex: 'IsTeacher'
    	}, {
    	     id:'IsExpert',
    	     header: '是否专家',
    	     allowBlank: false,
    	     width:80,
    	     editable:false,
    	     dataIndex: 'IsExpert'
    	}, {
    	     id:'EthicalExperts',
    	     header: '是否伦理专家',
    	     allowBlank: false,
    	     width:80,
    	     editable:false,
			 hidden:true,
    	     dataIndex: 'EthicalExperts'
    	}/*,{
    	     id:'IsValid',
    	     header: '是否有效',
    	     allowBlank: false,
    	     width:100,
    	     editable:false,
    	     dataIndex: 'IsValid',
			 renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
    	}, {
    	     id:'Monographnum',
    	     header: '出版专著',
    	     allowBlank: false,
    	     width:200,
    	     editable:false,
    	     dataIndex: 'Monographnum'
    	}, {
    	     id:'Papernum',
    	     header: '发表论文',
    	     allowBlank: false,
    	     width:200,
    	     editable:false,
    	     dataIndex: 'Papernum'
    	}, {
    	     id:'Patentnum',
    	     header: '专利',
    	     allowBlank: false,
    	     width:200,
    	     editable:false,
    	     dataIndex: 'Patentnum'
    	}, {
    	     id:'InvincustomstanNum',
    	     header: '参与定制技术标准',
    	     allowBlank: false,
    	     width:200,
    	     editable:false,
    	     dataIndex: 'InvincustomstanNum'
    	}, {
    	     id:'Trainnum',
    	     header: '培养人才',
    	     allowBlank: false,
    	     width:200,
    	     editable:false,
    	     dataIndex: 'Trainnum'
    	}, {
    	     id:'Holdtrainnum',
    	     header: '举办培训班',
    	     allowBlank: false,
    	     width:200,
    	     editable:false,
    	     dataIndex: 'Holdtrainnum'
    	}, {
    	     id:'InTrainingNum',
    	     header: '参与培训班',
    	     allowBlank: false,
    	     width:100,
    	     editable:false,
    	     dataIndex: 'InTrainingNum'
    	} */
			    
]);

var addButton = new Ext.Toolbar.Button({
					text : '新增',
					//tooltip : '增加',
					iconCls : 'edit_add',
					handler : function() {
						srmdeptuserAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '修改',
					//tooltip : '修改',
					iconCls : 'pencil',
					handler : function() {
						srmdeptuserEditFun();
					}
				});
var delButton = new Ext.Toolbar.Button({
			text : '删除',
			//tooltip : '删除',
			iconCls : 'edit_remove',
			handler : function() {
				var rowObj = itemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				var tmpRowid = "";
		
				if (len < 1) {
					Ext.Msg.show({
								title : '注意',
								msg : '请选择需要删除的数据!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				} else {
					tmpRowid = rowObj[0].get("rowid");
					Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function(btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url : itemGridUrl + '?action=del&rowid=' + tmpRowid,
								waitMsg : '删除中...',
								failure : function(result, request) {
									Ext.Msg.show({
												title : '错误',
												msg : '请检查网络连接!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
													title : '注意',
													msg : '操作成功!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										itemGridDs.load({
													params : {
														start : 0,
														limit : 25
													}
												});
									} else {
										var msg=jsonData.info;
										Ext.Msg.show({
													title : '错误',
													msg : msg,
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
												});
									}
								},
								scope : this
							});
						}
					})
				}
			}
});
//打印程序添加说明
//MethodGetServer s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRMedBaseCtl.GetServerInfo"))
//MethodGetData   s val=##Class(%CSP.Page).Encrypt($LB("类方法"))
//DHC.WMR.CommonFunction.js,DHC.WMR.ExcelPrint.JS,
//btnPrint  打印  websys/print_compile.gif
//btnExport 打印  websys/print_compile.gif
var xls=null;
var xlBook=null;
var xlSheet=null;
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);

function GetWebConfig(encmeth){
	var objWebConfig=new Object();
	if (encmeth!=""){
		if (encmeth!=""){
			var TempFileds=encmeth.split(String.fromCharCode(1));
			objWebConfig.CurrentNS=TempFileds[0];
			objWebConfig.MEDDATA=TempFileds[1];
			objWebConfig.LABDATA=TempFileds[2];
			objWebConfig.Server="cn_iptcp:"+TempFileds[3]+"[1972]";
			objWebConfig.Path=TempFileds[4];
			objWebConfig.LayOutManager=TempFileds[5];
		}
	}else{
		objWebConfig=null;
	}
	return objWebConfig;
}
function fillxlSheet(xlSheet,cData,cRow,cCol)
{
	var cells = xlSheet.Cells;
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			cells(cRow+i,cCol+j).Value = arryDataY[j];
			//cells(cRow+i,cCol+j).Borders.Weight = 1;0
		}
	}
	return cells;
}

function Cleanup(){
	window.clearInterval(idTmr);
	CollectGarbage();
}

//画单元格
function AddCells(objSheet,fRow,fCol,tRow,tCol,xTop,xLeft)
{
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(2).LineStyle=1;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}

//单元格合并
function MergCells(objSheet,fRow,fCol,tRow,tCol)
{
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).MergeCells =1;
}

//单元格对其
//-4130 左对齐
//-4131 右对齐
//-4108 居中对齐
function HorizontCells(objSheet,fRow,fCol,tRow,tCol,HorizontNum)
{
   objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).HorizontalAlignment=HorizontNum;
}
/**
function ExportDataToExcel(strMethodGetServer,strMethodGetData,strTemplateName)
{
	
	alert("ahhahahah");
	var objCaseSrv = ExtTool.StaticServerObject("herp.srm.udata.uSRMuser");
	var ServerInfo=objCaseSrv.GetServerInfo();
	var TemplatePath=GetWebConfig(ServerInfo).Path;
	var FileName=TemplatePath+"\\\\"+"SRMUser.xls";
	try {
		xls = new ActiveXObject ("Excel.Application");
	}catch(e) {
		alert("创建Excel应用对象失败!");
		return false;
	}
	xls.visible=false;
	xlBook=xls.Workbooks.Add(FileName);
	xlSheet=xlBook.Worksheets.Item(1);
	//var flg=objCaseSrv.ExportCRRepZLk("fillxlSheet",strArguments);
	//var flg=cspRunServerMethod(strMethod,"fillxlSheet",strArguments);
	var flg=objCaseSrv.ExportToExcel("fillxlSheet");
	var fname = xls.Application.GetSaveAsFilename("QQQ","Excel Spreadsheets (*.xls), *.xls");
	xlBook.SaveAs(fname);
	xlSheet=null;
	xlBook.Close (savechanges=true);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	idTmr=window.setInterval("Cleanup();",1);

	return true;
}
**/

function ExportDataToExcel(strMethodGetServer,strMethodGetData,strTemplateName)
{
	try {
	xls = new ActiveXObject ("Excel.Application");
	Ext.Ajax.request({

		url : itemGridUrl + '?action=getWebConfig',
		waitMsg : '获取网络信息...',
		failure : function(result, request) {
            Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR
			});
		},
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
			var ServerInfo=jsonData.info;
	        var TemplatePath=GetWebConfig(ServerInfo).Path;
			Ext.Ajax.request({
			url : itemGridUrl + '?action=export&itmjs='+'fillxlSheet',
			waitMsg : '导出中...',
		    failure : function(result, request) {
			    Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR
			});
		},
		    success : function(result, request) {
			    //alert(result.responseText);
			    //var jsonData = Ext.util.JSON.decode(result.responseText);
				//alert(jsonData);
			    //if (jsonData.success == 'true') 
				//{
				//alert(result.responseText);
				
				//alert(flg);
			    var FileName=TemplatePath+"\\\\"+"SRMUser.xls";
			    //alert(FileName);
			    xls.visible=false;
	            xlBook=xls.Workbooks.Add(FileName);
	            xlSheet=xlBook.Worksheets.Item(1);
				var flg=result.responseText;
				//alert(flg);
				eval(flg); //执行变量里的命令用eval函数
				/**
				fillxlSheet(xlSheet,'31-131',2,1);
                fillxlSheet(xlSheet,'王志',2,2);
                fillxlSheet(xlSheet,'本部药品调剂科',2,3);
                fillxlSheet(xlSheet,'药剂岗位',2,4);
                fillxlSheet(xlSheet,'副主任药师',2,5);
				**/
			    var fname = xls.Application.GetSaveAsFilename("科研人员数据","Excel Spreadsheets (*.xls), *.xls");
	            xlBook.SaveAs(fname);
	            xlSheet=null;
	            xlBook.Close (savechanges=true);
	            xls.Quit();
	            xlSheet=null;
	            xlBook=null;
	            xls=null;
	            idTmr=window.setInterval("Cleanup();",1);
	            alert("导出成功!");
	            return true;
	            	
		//} else {
				//Ext.Msg.show({title : '错误',msg : '错误',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR
				//});
				//}
	},
	scope : this
});
										
} else {
	    //alert("3");
		Ext.Msg.show({title : '错误',msg : '错误',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR
		});
		}
},
	scope : this
});
}catch(e){
		alert("创建Excel应用对象失败!");
		return false;
	}
}

var ExportButton = new Ext.Toolbar.Button({
					text : '导出',
					//tooltip : '导出',
					iconCls : 'export',
					handler : function() {
						ExportDataToExcel("","","");
					}
				});
//导入按钮
var importButton = {
	text: '导入excel数据',
    //tooltip:'导入',
	//disabled:userCode=='demo1'?false:true,	
    iconCls:'import',
	handler:function(){importExcel()}
			
};
var itemGrid = new Ext.grid.GridPanel({
			title: '科研人员信息维护',
			iconCls: 'list',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.srmuserexe.csp',
		    atLoad : true, // 是否自动刷新
			store: itemGridDs,
			cm: itemGridCm, 
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			//tbar:[addButton,'-',editButton,'-',delButton,'-',ExportButton,'-',importButton],  xm--青医附院导出需求
			tbar:['','用户编码','',uCodeField,'','用户名称','',uNameField,'','用户类型','',uTypeGridField,'-',findButton,'-',addButton,'-',editButton,'-',delButton],   
			bbar:itemGridPagingToolbar
});


  itemGridDs.load({	
			params:{start:0, limit:25},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});
  var srmdeptuserDs=function(){	
		var type=Ext.getCmp('uTypeGridField').value;
		if (type==undefined){type=""}
	    itemGridDs.proxy = new Ext.data.HttpProxy({
	    	
								url : 'herp.srm.srmuserexe.csp?action=list&code='+ encodeURIComponent(uCodeField.getValue())+ 
								'&name='+encodeURIComponent(Ext.getCmp('uNameField').getRawValue())+
								'&type='+ encodeURIComponent(type),
								
								method : 'GET'
								//'&type='+ userTypeField.getValue()
							});
					itemGridDs.load({
								params : {
									start : 0,
									limit : 25,
									dir:'',
									sort:''
								}
							});
	};
