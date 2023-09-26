function InitDescScreen(){    // InitwinScreen
	var obj = new Object();
	
	//-----------------------------------------------------
	obj.winfDemName = new Ext.form.TextField({ //winfPMenuCode
		id : 'winfDemName'
		,margins : '{50,0,0,0}'
		,allowBlank : false
		,fieldLabel : '����'
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
		,fieldLabel : '����'
		//,width : 50
		,anchor : '30%'
});
obj.winfEmergency = new Ext.form.TextField({ //winfPIconClass
		id : 'winfEmergency'
		,fieldLabel : '�����̶�'
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
		,fieldLabel : '����ģ��'
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
		,fieldLabel : '�������'
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
		,fieldLabel : '������'
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
		,fieldLabel : '�绰'
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
		,fieldLabel : '��������'
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
        title: '�ϴ��ļ�',
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
                                         fieldLabel: '�ִ������ļ�',
                                         inputType: 'file',
                                         buttonText: '���',
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
                    text:'�ϴ�',
                    iconCls: 'icon_uploading',
                    handler: function() {
                    
                    if (!formPanel.getForm().isValid()) {
                        Ext.MessageBox.alert("��Ϣ", "��������֤ʧ�ܣ�����ȷ��д������");
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
		,title : '������Ϣ'
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
		,title : '������ʷ'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '����״̬', width: 100, dataIndex: 'DemStatus', sortable: true
			,renderer : function(value, metaData, record, rowIndex, colIndex, store) {
					var strRet = "";
					switch (record.get("DemStatus")) {
						case "��˲�ͨ��" :
							strRet = "<div style='color:red';font-weight:bold>" + value + "</div>";
							break;
						case "�ύ" :
							strRet = "<div style='color:green'>" + value + "</div>";
							break;
						case "����" :
							strRet = "<div style='color:orange'>" + value + "</div>";
							break;
						case "����" :
							strRet = "<div style='color:#8968CD'>" + value + "</div>";
							break;
						case "���1" :
							strRet = "<div style='color:blue'>" + value + "</div>";
							break;
						case "����" :
							strRet = "<div style='color:gray'>" + value + "</div>";
							break;
						default :
							strRet = "<div style='color:black'>" + value + "</div>";
							break;
					}
					return strRet;
				}
			
			
			
			
			
			
			
			}
			,{header: '������', width: 100, dataIndex: 'Operator', sortable: true}
			,{header: '��������', width: 100, dataIndex: 'OperaDate', sortable: true}
			,{header: '����ʱ��', width: 100, dataIndex: 'OperaTime', sortable: true}
		]});
	
	//��������
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
		,title : '��������'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '��������', width: 100, dataIndex: 'attachment', sortable: true}
			,{header: '�ϴ�����', width: 100, dataIndex: 'UpDate', sortable: true}
			,{header: '�ϴ��û�', width: 100, dataIndex: 'UpUser', sortable: true}
			//,{header: '���ظ���', width: 100, dataIndex: 'button', renderer:showbutton}
			,{header : "���ظ���",width : 150,dataIndex : 'node',align : 'center'
			,renderer: function (value, meta, record) {  
    //�����ﶨ����3������,�ֱ��費ͬ��css class�Ա�����  
    var formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='alarm_detail'>����</a>";  
    var resultStr = String.format(formatStr, record.get('id'), record.get('id'), record.get('id'));  
    return "<div class='controlBtn'>" + resultStr + "</div>";  
  }.createDelegate(this)
 
  }
		]});
		
		//�����¼�  
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
	
	Ext.MessageBox.alert('Status', '�ļ��Ѵ��������ص�C:�̸�Ŀ¼��');
  }  
},  
this);  

var BrowseFolder=function(name) {
	 
	 var fd = new ActiveXObject("MSComDlg.CommonDialog");
       fd.Filter = "��������(*)"; //�^�V�ļ����
       fd.filename=name
       fd.FilterIndex = 2;
       fd.MaxFileSize = 128;
       //fd.ShowOpen();//�򿪶Ի���
       fd.ShowSave();//����Ի���
       VerStr=fd.filename;//fd.filename·��
	   
	   //return VerStr;
}
	
	//------------------------------------------------------------------------------------------------------
	
		
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 600
		,buttonAlign : 'center'
		,width : 700
		,modal : true
		,title : '������Ϣ'
		,layout : 'border'
		,items:[
			obj.winTPanelName
			
			,obj.winfDownPanel
			
			,obj.winfGPanel
			
		]
	});
	
	
	InitDetailScreenEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
  
  return obj;
}