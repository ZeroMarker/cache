//需求明细
function InitDescScreen(){    // InitwinScreen
	var obj = new Object();
	 var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	 var ip=getIpAddress();
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
		,anchor : '100%'
});

//-----------------------------------
obj.winTypePanel = new Ext.Panel({
		id : 'winTypePanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.winfDemType
		]
	});
	obj.winfInHandler = new Ext.form.TextField({ //winfPLinkUrl
		id : 'winfInHandler'
		,fieldLabel : '科内需求处理人'
		//,width : 50
		,anchor : '70%'
});

obj.winInHandlerPanel = new Ext.Panel({
		id : 'winInHandlerPanel'
		,buttonAlign : 'center'
		,columnWidth : .7
		,layout : 'form'
		,items:[
			obj.winfInHandler
		]
	});
	
	obj.wintoPanel1 = new Ext.form.FormPanel({
		id : 'wintoPanel1'
		,buttonAlign : 'center'
		//,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.winTypePanel
			,obj.winInHandlerPanel
		]
	});

//-----------------------------
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
		//,columnWidth : .4
		,fieldLabel : '需求描述'
		//,editable:true
		,anchor : '100%'
	});
	obj.DemDescPanel = new Ext.Panel({
		id : 'DemDescPanel'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.winfDemDesc
			
		]
	});
	obj.winfEditDemDesc = new Ext.form.TextArea({ //winfPIconClass
		id : 'winfEditDemDesc'
		,height : 150
		//,columnWidth : .4
		,fieldLabel : '修改需求'
		//,editable:true
		,style:'color:red'
		,anchor : '100%'
	});
	obj.EditDemDescPanel = new Ext.Panel({
		id : 'EditDemDescPanel'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.winfEditDemDesc
			
		]
	});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		//,region:'center'
		,text : '修改'
		//,hidden:true
		,anchor : '20%'
	});
		obj.winbtnSave = new Ext.Panel({
		id : 'winbtnSave'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.btnSave
			
		]
	});
	obj.winTPanelDesc = new Ext.Panel({
		id : 'winTPanelDesc'
		,buttonAlign : 'center'
		//,columnWidth : .4
		,layout : 'column'
		,items:[
			obj.DemDescPanel
			,obj.EditDemDescPanel
			,obj.winbtnSave
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
			//,obj.winfDemType
			,obj.wintoPanel1
			,obj.winFPanel1
			,obj.winFPanel4
			,obj.winTPanelDesc
			//,obj.formPanel
			,obj.DemandID
		]
	});
	
	//-----------------------------------------------------
	//状态列表
	
	
	
	
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
			,{name: 'toAudiUser', mapping: 'toAudiUser'}
			,{name: 'toAudiUserLoc', mapping: 'toAudiUserLoc'}
			,{name: 'note', mapping: 'note'}
		])
	});
	//obj.winfGPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.winfGPanel = new Ext.grid.GridPanel({
		id : 'winfGPanel'
		,store : obj.winfGPanelStore
		,columnWidth : .7
		//,region : 'center'
		,collapsible: true
		//,columnLines : true
		,height: 250
		//,autoHeight:true
		,title : '操作历史'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			
			,{header: '需求状态', width: 150, dataIndex: 'DemStatus', sortable: true
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
			,{header: '操作人', width: 80, dataIndex: 'Operator', sortable: true}
			,{header: '操作日期', width: 80, dataIndex: 'OperaDate', sortable: true}
			,{header: '操作时间', width: 80, dataIndex: 'OperaTime', sortable: true}
			,{header: '指定审核人', width: 80, dataIndex: 'toAudiUser', sortable: true}
			,{header: '审核人科室', width: 100, dataIndex: 'toAudiUserLoc', sortable: true}
			,{header : "备注",width : 80,dataIndex : 'comContent',align : 'center'
			,renderer: function (value, metaData, record, rowIndex, colIndex, store) 
			{  
				//var formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'><img src='../scripts/dhcmed/img/export.png'/></a>";  
				//var formatStr = formatStr+" "+"<a href='javascript:void({1});' onclick='javscript:return false;' class='PMEdit'><img src='../scripts/dhcmed/img/edit.gif'/></a>";
				var strRet = "";
				if(record.get("note")!="")
				{
					
					formatStr = "<a href='javascript:void({0});' onclick='javscript:return false; ' class='PMlookat'>查看</a>";
	
							strRet = "<div style='color:red;font-weight:bold' class='PMCheckNote' >" + formatStr + "</div>";
				}
				
				
				
					return strRet;
 
			}
			}
		]});
		
	//***************************************************************************
	//沟通列表
	obj.winfComlistStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.winfComlistStore = new Ext.data.Store({
		proxy: obj.winfComlistStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'
			//idProperty: 'RecRowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'RecRowid', mapping: 'RecRowid'}
			,{name: 'ComDate', mapping: 'ComDate'}
			,{name: 'ComTime', mapping: 'ComTime'}
			,{name: 'Location', mapping: 'Location'}
			,{name: 'HosStr', mapping: 'HosStr'}
			,{name: 'DHCCStr', mapping: 'DHCCStr'}
			,{name: 'OtherStr', mapping: 'OtherStr'}
			,{name: 'COmMethod', mapping: 'COmMethod'}
			,{name: 'ComDuration', mapping: 'ComDuration'} 
			,{name: 'COmContent', mapping: 'COmContent'} 
			
		])
	});
	//obj.winfGPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.winflistPanel = new Ext.grid.GridPanel({
		id : 'winflistPanel'
		,store : obj.winfComlistStore
		,columnWidth : .3
		//,region : 'center'
		,height: 250
		,collapsible: true
		//,columnLines : true
		//,height: 150
		//,autoHeight:true
		,title : '沟通记录'
		,buttonAlign : 'center'
		//,sm: new Ext.grid.RowSelectionModel({ singleSelect: true })
		,columns: [
			new Ext.grid.RowNumberer()
			,{header : "沟通内容",width : 80,dataIndex : 'comContent',align : 'center'
			,renderer: function (value, metaData, record, rowIndex, colIndex, store) 
			{  
				//var formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'><img src='../scripts/dhcmed/img/export.png'/></a>";  
				//var formatStr = formatStr+" "+"<a href='javascript:void({1});' onclick='javscript:return false;' class='PMEdit'><img src='../scripts/dhcmed/img/edit.gif'/></a>";
				var strRet = "";
				
				formatStr = "<a href='javascript:void({0});' onclick='javscript:return false; ' class='PMWatch'>查看</a>";
	
							strRet = "<div style='color:red;font-weight:bold' class='PMCheckNote' >" + formatStr + "</div>";
				
					return strRet;
 
			}
			}
			,{header: 'RecRowid', width: 100, dataIndex: 'RecRowid', sortable: true,hidden:true}
			,{header: '沟通日期', width: 100, dataIndex: 'ComDate', sortable: true}
			,{header: '沟通时间', width: 100, dataIndex: 'ComTime', sortable: true}
			/* ,{header: 'Location', width: 100, dataIndex: 'Location', sortable: true}
			,{header: 'HosStr', width: 100, dataIndex: 'HosStr', sortable: true}  */
		]});
		
		
		
		
		obj.winTotalGridPanel = new Ext.Panel({
		id : 'winTotalGridPanel'
		,region : 'center'
		,layout:'column'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		//,collapsible: true
		//,columnWidth : .5
		
		,items:[
			obj.winfGPanel
			,obj.winflistPanel
		]
	});

	//***************************************************************************
		
	
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
			,{name:'ADRowid',mapping:'ADRowid'}
			,{name:'Filename',mapping:'Filename'}
		])
	});
	//obj.winfGPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.winfDownPanel = new Ext.grid.GridPanel({
		id : 'winfDownPanel'
		,store : obj.winfDownLoadStore
		,region : 'south'
		,collapsible: true
		,collapsed:true
		//,columnLines : true
		,height: 150
		//,autoHeight:true
		,title : '附件下载'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '附件名称', width: 100, dataIndex: 'attachment', sortable: true}
			,{header: 'Rowid', width: 100, hidden:true,dataIndex: 'ADRowid', sortable: true}
			,{header: '服务器文件名', width: 100, hidden:true,dataIndex: 'Filename', sortable: true}
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
	var ADRowid=record.get("ADRowid");
	var Filename=record.get("Filename");
	BrowseFolder(attachName);  //
	if (VerStr==Filename){
	return;
	}
	var ret=FileDownload(VerStr,Filename,"DownLoad");
	if (ret==true){
	var Down='下载成功，文件保存在'+VerStr;
	var ret=objApply.PMPDownloads(ADRowid,'PMP_ImprovementAdjunct',ip)
	}
	else{
	var Down='下载失败！';
	};
	Ext.MessageBox.alert('Status', Down);
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
	   
	   return VerStr;
}
	
	//------------------------------------------------------------------------------------------------------
	
		
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 600
		,buttonAlign : 'center'
		,width : 1000
		,modal : true
		,title : '申请信息'
		,layout : 'border'
		,items:[
			obj.winTPanelName
			//,obj.winflistPanel
			,obj.winTotalGridPanel
			//,obj.winfGPanel
			,obj.winfDownPanel
			
			
			
		]
	});
	
	
	InitDetailScreenEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
  
  return obj;
}

//查看沟通记录详情
function ComMiniScreen(){    // InitwinScreen
	var obj = new Object();
	
	
	//********************************************************
	
	obj.miniComDate = new Ext.form.TextField({ //winfPMenuCode
		id : 'miniComDate'
		//,margins : '{50,0,0,0}'
		//,allowBlank : false
		,fieldLabel : '沟通日期'
		,anchor : '100%'
});
	//------------------------------------------
	/* obj.ComDate = new Ext.form.DateField({
		id : 'ComDate'
		,format : 'Y-m-d'
		//,width : 100
		//,columnWidth : .3
		,fieldLabel : '沟通日期'
		,anchor : '100%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,plugins: 'monthPickerPlugin'
		//,value : new Date()
	}); */
	
	obj.winminiComDate = new Ext.Panel({
		id : 'winminiComDate'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.miniComDate
		]
	});
	obj.miniComTime = new Ext.form.TextField({ //winfPMenuCode
		id : 'miniComTime'
		//,margins : '{50,0,0,0}'
		//,allowBlank : false
		,fieldLabel : '沟通时间'
		,anchor : '100%'
});
	/* obj.ComTime = new Ext.form.TimeField({
		id : 'ComTime'
		//,format : 'Y-m-d'
		//,width : 100
		//,columnWidth : .3
		,fieldLabel : '沟通时间'
		,anchor : '100%'
		//,altFormats : 'Y-m-d|d/m/Y'
		//,plugins: 'monthPickerPlugin'
		//,value : new Time()
	}); */
	
	obj.winminiComTime = new Ext.Panel({
		id : 'winminiComTime'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.miniComTime
		]
	});
	
	
	obj.winminiFPanel1 = new Ext.form.FormPanel({
		id : 'winminiFPanel1'
		,buttonAlign : 'center'
		//,height: 300
		,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.winminiComDate
			,obj.winminiComTime
			
		]
	});
	
	obj.miniComDuration = new Ext.form.TextField({
		id : 'miniComDuration'
		,fieldLabel : '沟通时长'
		,columnWidth : .5
		,anchor : '100%'
});

obj.winminiDuration = new Ext.Panel({
		id : 'winminiDuration'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.miniComDuration
		]
	}); 

/* obj.cmbComWay = Common_ComboToDic("cmbComWay","沟通方式","Communication");	//Communication */
	obj.miniComWay = new Ext.form.TextField({
		id : 'miniComWay'
		,fieldLabel : '沟通方式'
		,columnWidth : .5
		,anchor : '100%'
});
obj.winminiComWay = new Ext.Panel({
		id : 'winminiComWay'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.miniComWay
		]
	});

	obj.winminiPanel2 = new Ext.form.FormPanel({
		id : 'winminiPanel2'
		,buttonAlign : 'center'
		//,height: 300
		,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.winminiDuration
			,obj.winminiComWay
			
		]
	});
	
	
	obj.miniHosStr = new Ext.form.TextField({
		id : 'miniHosStr'
		,fieldLabel : '院方与会人'
		,columnWidth : .5
		,anchor : '100%'
});



obj.winminiHosStr = new Ext.Panel({
		id : 'winminiHosStr'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		//,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.miniHosStr
		]
	}); 
		obj.txtminiPrjStr = new Ext.form.TextField({
		id : 'txtminiPrjStr'
		,fieldLabel : '公司与会人'
		//,columnWidth : .6
		,anchor : '100%'
});
	obj.winminiPrjStr = new Ext.Panel({
		id : 'winminiPrjStr'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		//,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.txtminiPrjStr
		]
	});
	
	obj.txtminiOtherStr = new Ext.form.TextField({
		id : 'txtminiOtherStr'
		,fieldLabel : '其他与会者'
		//,columnWidth : .6
		,anchor : '100%'
});
	obj.winminiOtherStr = new Ext.Panel({
		id : 'winminiOtherStr'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.txtminiOtherStr
		]
	});
	
		obj.miniLocation = new Ext.form.TextField({
		id : 'miniLocation'
		,fieldLabel : '地点'
		//,columnWidth : .6
		,anchor : '100%'
		});
		
		obj.winminiLocation = new Ext.Panel({
		id : 'winminiLocation'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.miniLocation
		]
	});
	
	obj.winminiPanel3 = new Ext.Panel({
		id : 'winminiPanel3'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		//,columnWidth : .5
		,layout : 'column'
		,items:[
			obj.winminiOtherStr
			,obj.winminiLocation
		]
	});
	
	
	obj.txtminiComNote = new Ext.form.TextArea({ //winfPIconClass
		id : 'txtminiComNote'
		,height : 150
		,fieldLabel : '沟通内容'
		,anchor : '90%'
	});
	
	obj.winminiComNote = new Ext.Panel({
		id : 'winminiComNote'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		//,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.txtminiComNote
		]
	});
	

		obj.miniformPanal=new Ext.Panel({
			id : 'miniformPanal'
			//,title : '需求'
			,layout : 'form'
			,region:'center'
			//,width : '30%'
			//,height : 500
			//,height: '100%'
			//,region : 'center'
			,split: true
			//,columnWidth: 0.80
			//,columnWidth: 0.40
			//,collapsible: true
			,frame:true
			//,collapseDirection:'bottom'
			//,margins: '0 0 0 5'
			//,autoScroll : true
			//,animCollapse: true
			//,border:true
			//,width : 300
			,items:[
			
			obj.winminiFPanel1
			,obj.winminiPanel2
			,obj.winminiHosStr
			,obj.winminiPrjStr 
			,obj.winminiPanel3
			,obj.winminiComNote
			
		]
		
			
		});
		
	obj.winminiScreen = new Ext.Window({
		id : 'winminiScreen'
		,height : 350
		,buttonAlign : 'center'
		,width : 480
		,modal : true
		,title : '沟通信息'
		,layout : 'border'
		
		,items:[
			
			
			obj.miniformPanal
			
		]
	});
	ComMiniScreenEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	
	return obj;
}

//查看备注详情
function MiniNoteScreen(){    // InitwinScreen
	var obj = new Object();
	 obj.txtminiNote=new Ext.form.HtmlEditor({
	    id:'txtminiNote'
	    ,xtype: "htmleditor",
        name: "content",
        //fieldLabel: "内容",
        height: 300,
		enableSourceEdit: false
		//enableAlignments: false,//是否启用对齐按钮，包括左中右三个按钮 
        //enableColors: false,//是否启用前景色背景色按钮，默认为true
        //enableFont: false,//是否启用字体选择按钮 默认为true
        //enableFontSize: false,//是否启用字体加大缩小按钮 
        //enableFormat: false,//是否启用加粗斜体下划线按钮
        //enableLists: false, //是否启用列表按钮
		//enableLinks:false
	    })
	obj.winminiComNote = new Ext.Panel({
		id : 'winminiComNote'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		//,columnWidth : .4
		,form:true
		,layout : 'column'
		,items:[
			obj.txtminiNote
		]
	});
	
	obj.miniNotScreen = new Ext.Window({
		id : 'miniNotScreen'
		,height : 300
		,buttonAlign : 'center'
		,width : 500
		,modal : true
		,frame:true
		,title : '备注信息'
		,layout : 'form'
		
		,items:[
			
			
			obj.winminiComNote
			
		]
	});
	
	
	return obj;
	
}
