/**
 * ����: ͼƬչʾ����
 * 
 * ����: ��д�ߣ�xuchao ��д����: 2014.5.22
 * 
 * @param {}
 *            store �а������ֶ� rowid ɾ��ʱ��Ӧ��rowid picsrc ͼƬ��·��
 * 
 */
var cus = null;
var PicWin=null;
var gParam = [];
var DisplayAllTypes=false;

function GetParam() {
	var userId = session['LOGON.USERID'];
	var groupId = session['LOGON.GROUPID'];
	var locId = session['LOGON.CTLOCID'];
	var url = 'dhcstm.ftpcommon.csp?actiontype=GetParamProp&GroupId=' + groupId
			+ '&LocId=' + locId + '&UserId=' + userId;
	var response = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(response);
	if (jsonData.success == 'true') {
		var info = jsonData.info;
		if (info != null || info != '') {
			gParam = info.split('^');
		}
	}

	return;
}

if (gParam.length < 1) {
	GetParam(); // ��ʼ����������
}

var sellist="";
////flag �ж��Ƿ����store��formpanel
ShowwarnPicWindow = function(Store) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var ftpsrc = "http://" + gParam[5];
	
	if (PicWin)
	{
		PicWin.show();
		return;
	}
					
	var picTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<div style="padding:5px; height:160px; width:160px; float:left;" class="select_pic" >',
		'<img  class="pic" src="'
				+ ftpsrc
				+ '{picsrc}"style="height:150px; width:150px;"position: relative;>',
		'<p>{type}</p>',		
		'</div>', '</tpl>');
	var picView = new Ext.DataView({
		store : Store,
		tpl : picTpl,
		frame : true,
//		multiSelect:true,
		singleSelect : true,
		trackOver : true,
		selectedClass : 'selected-pic',
		overClass : 'over-pic',
		itemSelector : 'div.select_pic',
		emptyText : '��ѡ��Ҫ��ʾ������ͼƬ',
		listeners : {
			'dblclick' : function(v, r) {
				var src = Store.getAt(r).get('picsrc')
				Ext.get("custom").dom.src = ftpsrc + src;
				//��ȡͼƬ��ʵ�ʴ�С
				var image = new Image();
				image.src = ftpsrc + src;
				document.body.appendChild(image); //����ͼƬ
				if (!cus) {
					cus = new Ext.Resizable("custom", {
						wrap : true,
						pinned : true,
						preserveRatio : true,
						dynamic : true,
						handles : 'all', // shorthand for 'n
						draggable : true
					});
				}
                var customEl = cus.getEl();
				customEl.on('dblclick', function() {
					cus.resizeTo(1, 1)
					flag=0
					PicWin.show()
				});
				var height = 600 ;// /����Ĭ�ϸ߶�
				var width = image.width / (image.height / height)  ;// /���ձ�������
																	// ��ֹ����
				cus.resizeTo(width, height);
				PicWin.hide();
			}

		}

	})

	var exitBt=new Ext.Toolbar.Button({
		text:'�˳�',
		iconCls : 'page_goto',
		handler:function()
		{		
			PicWin.hide();
		}
	});
	var displayAllPic = new Ext.Toolbar.Button({
		text:'��ʾȫ��',
		iconCls : 'page',
		handler:function()
		{
			if (!DisplayAllTypes){
			Ext.getCmp("comLic").setValue(true);
			Ext.getCmp("taxLic").setValue(true);
			Ext.getCmp("orgCode").setValue(true);
			Ext.getCmp("drugBusLic").setValue(true);
			Ext.getCmp("insBusLic").setValue(true);
			Ext.getCmp("insProLic").setValue(true);
			Ext.getCmp("legalComm").setValue(true);
			Ext.getCmp("saleServComm").setValue(true);
			Ext.getCmp("agentAuth").setValue(true);	
			Ext.getCmp("qualityComm").setValue(true);
			Ext.getCmp("drugProLic").setValue(true);
			Ext.getCmp("gspLic").setValue(true);
			Ext.getCmp("insRegLic").setValue(true);
			Ext.getCmp("inletRegLic").setValue(true);
			Ext.getCmp("inletRLic").setValue(true);
			DisplayAllTypes=true;
			Ext.getCmp("drugRegLic").setValue(true);
			}else{
			Ext.getCmp("comLic").setValue(false);
			Ext.getCmp("taxLic").setValue(false);
			Ext.getCmp("orgCode").setValue(false);
			Ext.getCmp("drugBusLic").setValue(false);
			Ext.getCmp("insBusLic").setValue(false);
			Ext.getCmp("insProLic").setValue(false);
			Ext.getCmp("legalComm").setValue(false);				
			Ext.getCmp("saleServComm").setValue(false);				
			Ext.getCmp("agentAuth").setValue(false);				
			Ext.getCmp("qualityComm").setValue(false);				
			Ext.getCmp("drugProLic").setValue(false);				
			Ext.getCmp("gspLic").setValue(false);				
			Ext.getCmp("insRegLic").setValue(false);				
			Ext.getCmp("inletRegLic").setValue(false);				
			Ext.getCmp("inletRLic").setValue(false);
			DisplayAllTypes=false;
			Ext.getCmp("drugRegLic").setValue(false);
			picView.refresh();
			}
		}
	});
	
	
	
	var formPanel=new Ext.form.FormPanel({
			region:'north',
			height:100,
			baseCls:"x-plain",
			items:[{
            xtype: 'checkboxgroup',
            id:'mygroup',
            fieldLabel: 'ѡ��Ҫ��ʾ������',
            columns: 5,
            items: [
                {boxLabel: '����ִ��', name: 'comLic',id:'comLic'},
                {boxLabel: '˰��ִ��', name: 'taxLic',id:'taxLic'},
                {boxLabel: '��������', name: 'orgCode',id:'orgCode'},
                {boxLabel: 'ҩƷ��Ӫ���֤', name: 'drugBusLic',id:'drugBusLic'},
                {boxLabel: '��е��Ӫ���֤', name: 'insBusLic',id:'insBusLic'},
                {boxLabel: '��е�������֤', name: 'insProLic',id:'insProLic'},
                {boxLabel: '����ί����', name: 'legalComm',id:'legalComm'},
                {boxLabel: '�ۺ�����ŵ��', name: 'saleServComm',id:'saleServComm'},
                {boxLabel: '������Ȩ��', name: 'agentAuth',id:'agentAuth'},
                {boxLabel: '������ŵ��', name: 'qualityComm',id:'qualityComm'},
                {boxLabel: 'ҩƷ�������֤', name: 'drugProLic',id:'drugProLic'},
                {boxLabel: 'GSP��֤', name: 'gspLic',id:'gspLic'},
                {boxLabel: '��еע��֤', name: 'insRegLic',id:'insRegLic'},
                {boxLabel: '����ע��ǼǱ�', name: 'inletRegLic',id:'inletRegLic'},
                {boxLabel: '����ע��֤', name: 'inletRLic',id:'inletRLic'},
                {boxLabel: 'ҩƷע������', name: 'drugRegLic',id:'drugRegLic'}
                
            ],
           listeners:{
           	'change':function(_checkgroup,_arr){
	       		 sellist="";
	       	      for (var i=0;i<_arr.length;i++)
	       	       {
	       	       	 if(sellist==""){
	       	       	 sellist="'"+_arr[i].name+"'"
	       	       	 	}
	       	       	 else{
	       	         sellist=sellist+",'"+_arr[i].name+"'"
	       	       	 	}
	       	       }
	       	      if (!DisplayAllTypes)
	       	      {
	       	      	Store.load({params:{'rowid':currVendorRowId,'type':sellist}}) ;
	       	      }
       		}
           }
        }  ]                        

		 }
	)
	var detailPanel = new Ext.Panel({
		region:'center',
		autoScroll : true,
		tbar : ['->',displayAllPic,'-',exitBt],    //,'-',bDelete,'-',fileBt,fileCom
		items : picView
	});
		
	if(!PicWin){ 
		PicWin = new Ext.Window({
			title : 'ͼƬ��Ϣ',
			width : 820,
			height : 600,
			modal : true,
			closeAction:'hide',
			layout : 'border',
			 listeners:{
	   	      'show':function(){
	       	      Store.removeAll();
	       	      Store.load({params:{'rowid':currVendorRowId,'type':sellist}});
	   		 }
			 },
			
			items : [formPanel,detailPanel]
		});	
	}
	PicWin.show();
}