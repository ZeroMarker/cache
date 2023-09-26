function InitDescScreen(){    // InitwinScreen
	var obj = new Object();
	
	//-----------------------------------------------------
	obj.winfDemName = new Ext.form.TextField({ //winfPMenuCode
		id : 'winfDemName'
		,margins : '{50,0,0,0}'
		,allowBlank : false
		,fieldLabel : '名称'
		,anchor : '75%'
});
obj.winDemName = new Ext.Panel({
		id : 'winDemName'
		,buttonAlign : 'center'
		//,columnWidth : 1
		,layout : 'form'
		,items:[
			obj.winfDemName
		]
	});

	obj.winfDemType = new Ext.form.TextField({ //winfPLinkUrl
		id : 'winfDemType'
		,fieldLabel : '类型'
		//,width : 50
		,anchor : '30%'
});
obj.winfEmergency = new Ext.form.TextField({ //winfPIconClass
		id : 'winfEmergency'
		,fieldLabel : '紧急程度'
		,anchor : '100%'
});

obj.winTPanel1 = new Ext.Panel({
		id : 'winTPanel1'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.winfEmergency
		]
	});

obj.winfModule = new Ext.form.TextField({ //winfPIconClass
		id : 'winfModule'
		,fieldLabel : '所属模块'
		,anchor : '68%'
});

obj.winTPanel2 = new Ext.Panel({
		id : 'winTPanel2'
		,buttonAlign : 'center'
		,columnWidth : .7
		,layout : 'form'
		,items:[
			obj.winfModule
		]
	});
obj.winFPanel1 = new Ext.form.FormPanel({
		id : 'winFPanel1'
		,buttonAlign : 'center'
		//,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.winTPanel1
			,obj.winTPanel2
		]
	});


	
	
	obj.winfLocation = new Ext.form.TextField({ //winfPIconClass
		id : 'winfLocation'
		,fieldLabel : '发起科室'
		,anchor : '100%'
});
obj.winTPanelLoc = new Ext.Panel({
		id : 'winTPanelLoc'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.winfLocation
		]
	});

obj.winfCreater = new Ext.form.TextField({ //winfPIconClass
		id : 'winfCreater'
		,fieldLabel : '发起人'
		,anchor : '100%'
});
obj.winTPanelCreater = new Ext.Panel({
		id : 'winTPanelCreater'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.winfCreater
		]
	});

obj.winfPhone = new Ext.form.TextField({ //winfPIconClass
		id : 'winfPhone'
		,fieldLabel : '电话'
		,anchor : '100%'
});

obj.winTPanelPhone = new Ext.Panel({
		id : 'winTPanelPhone'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.winfPhone
		]
	});

	obj.winFPanel4 = new Ext.form.FormPanel({
		id : 'winFPanel4'
		,buttonAlign : 'center'
		//,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.winTPanelCreater
			,obj.winTPanelLoc
			,obj.winTPanelPhone
		]
	});
	obj.winfDemDesc = new Ext.form.TextArea({ //winfPIconClass
		id : 'winfDemDesc'
		,height : 150
		,fieldLabel : '需求描述'
		,anchor : '80%'
	});
	
	obj.winTPanelDesc = new Ext.Panel({
		id : 'winTPanelDesc'
		,buttonAlign : 'center'
		//,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.winfDemDesc
		]
	});
	obj.DemandID = new Ext.form.TextField({
		id : 'DemandID'
		,hidden : true
});	
//-------------------------------------------------------------------------------------------------
/*
obj.formPanel = new Ext.form.FormPanel({
        title: '上传文件',
        labelAlign: 'right',
        buttonAlign: 'center',
        labelWidth: 80,
        defaults: { autoWidth: true },
        padding: 10,
        frame: false,
        border: false,
        autoScroll: true,
        fileUpload: true,
        items: [       
                {
                    layout: 'column',
                    border: false,
                    columnWidth: 1,
                    items:
                     [
                      {
                          columnWidth: 1,
                          layout: 'form',
                          border: false,
                          items: [
                                   [
                                     {
                                         xtype: 'textfield',
                                         id: 'txtFile',
                                         fieldLabel: '仓储数据文件',
                                         inputType: 'file',
                                         buttonText: '浏览',
                                         width: 258
                                     }
                                    ]
                                 ]
                      }
                     ]
                }        
               ],
          bbar: [
                 {
                    text:'上传',
                    iconCls: 'icon_uploading',
                    handler: function() {
                    
                    if (!formPanel.getForm().isValid()) {
                        Ext.MessageBox.alert("信息", "表单输入验证失败，请正确填写完整！");
                        return;
                    }
 
                        formPanel.form.submit({
                            waitMsg: 'Uploading ....',
                            url: 'Upload.ashx',
                            method: "POST",
                            success: function(form, action) {
                             
                            },
                            failure:function(form,action){

                            }

                            }
                            
                        );
                        
                    }                 
                 }
                ]               
     });
	
*/

//--------------------------------------------------------------------------------------------------


	
obj.winTPanelName = new Ext.Panel({
		id : 'winTPanelName'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,margins : '{5,0,0,0}'
		,height:280
		,title : '申请信息'
		,layout : 'form'
		,region : 'north'
		,frame : true
		,items:[
			obj.winDemName
			,obj.winfDemType
			,obj.winFPanel1
			,obj.winFPanel4
			,obj.winTPanelDesc
			//,obj.formPanel
			,obj.DemandID
		]
	});
	
	//-----------------------------------------------------
	
	
	
	
	
	obj.winfGPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.winfGPanelStore = new Ext.data.Store({
		proxy: obj.winfGPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'
			//idProperty: 'DemRowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'DemStatus', mapping: 'DemStatus'}
			,{name: 'Operator', mapping: 'Operator'}
			,{name: 'OperaDate', mapping: 'OperaDate'}
			,{name: 'OperaTime', mapping: 'OperaTime'}
		])
	});
	//obj.winfGPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.winfGPanel = new Ext.grid.GridPanel({
		id : 'winfGPanel'
		,store : obj.winfGPanelStore
		,region : 'south'
		,collapsible: true
		//,columnLines : true
		,height: 150
		//,autoHeight:true
		,title : '操作历史'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '需求状态', width: 100, dataIndex: 'DemStatus', sortable: true
			,renderer : function(value, metaData, record, rowIndex, colIndex, store) {
					var strRet = "";
					switch (record.get("DemStatus")) {
						case "审核不通过" :
							strRet = "<div style='color:red';font-weight:bold>" + value + "</div>";
							break;
						case "提交" :
							strRet = "<div style='color:green'>" + value + "</div>";
							break;
						case "测试" :
							strRet = "<div style='color:orange'>" + value + "</div>";
							break;
						case "保存" :
							strRet = "<div style='color:#8968CD'>" + value + "</div>";
							break;
						case "审核1" :
							strRet = "<div style='color:blue'>" + value + "</div>";
							break;
						case "分配" :
							strRet = "<div style='color:gray'>" + value + "</div>";
							break;
						default :
							strRet = "<div style='color:black'>" + value + "</div>";
							break;
					}
					return strRet;
				}
			
			
			
			
			
			
			
			}
			,{header: '操作人', width: 100, dataIndex: 'Operator', sortable: true}
			,{header: '操作日期', width: 100, dataIndex: 'OperaDate', sortable: true}
			,{header: '操作时间', width: 100, dataIndex: 'OperaTime', sortable: true}
		]});
	
	//附件下载
	//-----------------------------------------------------------------------------------------------------
	obj.winfDownLoadProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.winfDownLoadStore = new Ext.data.Store({
		proxy: obj.winfDownLoadProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'
			//idProperty: 'DemRowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'attachment', mapping: 'attachment'}
			,{name: 'UpDate', mapping: 'UpDate'}
			,{name: 'UpUser', mapping: 'UpUser'}
			,{name: 'DownLoadFlag', mapping: 'DownLoadFlag'}
		])
	});
	//obj.winfGPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.winfDownPanel = new Ext.grid.GridPanel({
		id : 'winfDownPanel'
		,store : obj.winfDownLoadStore
		,region : 'center'
		,collapsible: true
		//,columnLines : true
		//,height: 250
		//,autoHeight:true
		,title : '附件下载'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '附件名称', width: 100, dataIndex: 'attachment', sortable: true}
			,{header: '上传日期', width: 100, dataIndex: 'UpDate', sortable: true}
			,{header: '上传用户', width: 100, dataIndex: 'UpUser', sortable: true}
			//,{header: '下载附件', width: 100, dataIndex: 'button', renderer:showbutton}
			,{header : "下载附件",width : 150,dataIndex : 'node',align : 'center'
			,renderer: function (value, meta, record) {  
    //在这里定义了3个操作,分别赋予不同的css class以便区分  
    var formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='alarm_detail'>下载</a>";  
    var resultStr = String.format(formatStr, record.get('id'), record.get('id'), record.get('id'));  
    return "<div class='controlBtn'>" + resultStr + "</div>";  
  }.createDelegate(this)
 
  }
		]});
		
		//单击事件  
obj.winfDownPanel.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
  var btn = e.getTarget('.controlBtn');  
  if (btn) {  
    var t = e.getTarget();  
    var record = obj.winfDownPanel.getStore().getAt(rowIndex);  
	var attachName=record.get("attachment");
	//alert(attachName);
	//var control = t.className; 
	//if (control)
	//{}

	BrowseFolder(attachName);
	vers="D:\\dthealth\\app\\dthis\\fujian\\";
	
	aa="copy "+vers+attachName+" "+"C:\\"+attachName;
	CreatBat(aa);
	
	Ext.MessageBox.alert('Status', '文件已存在您本地的C:盘根目录下');
  }  
},  
this);  

var BrowseFolder=function(name) {
	 
	 var fd = new ActiveXObject("MSComDlg.CommonDialog");
       fd.Filter = "所有类型(*)"; //過濾文件類型
       fd.filename=name
       fd.FilterIndex = 2;
       fd.MaxFileSize = 128;
       //fd.ShowOpen();//打开对话框
       fd.ShowSave();//保存对话框
       VerStr=fd.filename;//fd.filename路径
	   
	   //return VerStr;
}
	
	//------------------------------------------------------------------------------------------------------
	
		
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 600
		,buttonAlign : 'center'
		,width : 700
		,modal : true
		,title : '申请信息'
		,layout : 'border'
		,items:[
			obj.winTPanelName
			
			,obj.winfDownPanel
			
			,obj.winfGPanel
			
		]
	});
	
	
	InitDetailScreenEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
  
  return obj;
}