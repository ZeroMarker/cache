/**
 * ����: ͼƬչʾ����
 * 
 * ����: ��д�ߣ�xuchao ��д����: 2014.5.22
 * 
 * @param {}
 *            store �а������ֶ� rowid ɾ��ʱ��Ӧ��rowid picsrc ͼƬ��·��
 * 
 * @param {}
 *            Fndelete ���ý��淽�������ɾ�����ݿ���ͼƬ��Ϣ
 */
var cus = null;
var PicWin=null;
var gParam = [];

var DisplayAllTypes=false;
var num=0
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
ShowPicWindow = function(Store, FnDelete) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var ftpsrc = "http://" + gParam[5];

	Store.on('load',function(st){
		
		//��ʾ��һ��
		if (st.getCount()>0) 
		{
			picView.select(0);
		}
		else
		{initPic();}
	});

//	alert(sellist);
	if (PicWin)
	{
		PicWin.show();
		return;
	}
					
	var picTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<div style="padding:5px; height:110px; width:100px; float:left;" class="select_pic" >',
		'<img  class="pic" src="'
				+ ftpsrc
				+ '{picsrc}"style="height:100px; width:100px;"position: relative;>',
		'<p>{type}</p>',		
		'</div>', '</tpl>');

	var picTpl2 = new Ext.XTemplate(
		'<tpl for=".">',
		'<img  class="pic" src="'
				+ ftpsrc
				+ '{picsrc}"style="height:150px; width:160px;"position: relative;>',
		'<p>{type}</p>',		
		'</tpl>');	
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
	
var customEl=Ext.get("custom")
customEl.on('dblclick', function() {
					cus.resizeTo(1, 1);
					num=0
					cus.getEl().dom.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation='+num+')'; 
					flag=0;
					PicWin.show();
				});
customEl.on('contextmenu', function(e,t,o) {
					e.preventDefault();
					rightClick.showAt(e.getXY());

				});
	var rightClick = new Ext.menu.Menu({
			id:'rightClick',
			items: [
				{
					handler: function(){				
						num = (num + 1) % 4; 
						cus.getEl().dom.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation='+num+')'; 
					},
					text: '����ת'
				}, {
					handler: function(){				
						num = (num +3) % 4; 
						cus.getEl().dom.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation='+num+')'; 
					},
					text: '����ת'
				},{
					text:'��һ��',
					handler:function()
					{
							next(-1)
					}},
				{
				text:'��һ��',
				handler:function()
					{
						next(1)
					
			}}
	
			]
		});
	function next(i){
		var selArr=picView.getSelectedIndexes();
		var count=picView.getStore().getCount();
		if((i<0&&selArr[0]>0)||(i>0&&selArr[0]<count-1))
		{			 
		picView.select(selArr[0]+i,false);
		var src = picView.getStore().getAt(selArr[0]+i).get('picsrc')
		Ext.get("custom").dom.src = ftpsrc + src;
		// //��ȡͼƬ��ʵ�ʴ�С
		var image = new Image();
		image.src = ftpsrc + src;
		document.body.appendChild(image); //����ͼƬ
		var height = 600 ;// /����Ĭ�ϸ߶�
		var width = image.width / (image.height / height)  ;// /���ձ�����												// ��ֹ����
		cus.resizeTo(width, height);
		}else if(i<0)
		{
		Msg.info("warning","�Ѿ��ǵ�һ��!");
		}
		else if(i>0)
		{	Msg.info("warning","�Ѿ������һ��!");
		}
	}
	var picView = new Ext.DataView({
		store : Store,
		tpl : picTpl,
		frame : true,
//				multiSelect:true,
		singleSelect : true,
		autoScroll:true,
		trackOver : true,
		selectedClass : 'selected-pic',
		overClass : 'over-pic',
		itemSelector : 'div.select_pic',
		emptyText : '��ѡ��Ҫ��ʾ������ͼƬ',
		listeners : {
			'dblclick' : function(v, r) {
				var src = Store.getAt(r).get('picsrc')
				Ext.get("custom").dom.src = ftpsrc + src;
				// //��ȡͼƬ��ʵ�ʴ�С
				var image = new Image();
				image.src = ftpsrc + src;
				document.body.appendChild(image); //����ͼƬ
				var height = 600 ;// /����Ĭ�ϸ߶�
				var width = image.width / (image.height / height)  ;// /���ձ�������
																	// ��ֹ����
				cus.resizeTo(width, height);
				PicWin.hide();
			},
			'selectionchange':function(v,arrpicr)
			{
				var arrpicr = v.getSelectedRecords(); // ����
				if (arrpicr.length<1) return;
				var picr = arrpicr[0];
				// var row = picr.get("rowid");
				var picsrc = picr.get("picsrc");				
				var x=document.getElementById('pic') ;
				x.src=ftpsrc+picsrc;
			}

		}

	})
	var bDelete = new Ext.Toolbar.Button({
		text : 'ɾ��ѡ��ͼƬ',
		tooltip : 'ɾ��ѡ��ͼƬ',
		iconCls : 'page_delete',
		handler : function() {
			var arrpicr = picView.getSelectedRecords() // ����
			if ((!arrpicr)||(arrpicr.length==0) ) {
				Msg.info("warning", '��ѡ��Ҫɾ����ͼƬ!');
				return;
			}
			var picr = arrpicr[0];
			var row = picr.get("rowid");
			var picsrc = picr.get("picsrc");

			FnDelete(row, picsrc);
			Store.remove(picr);
			picView.refresh();

		}
	});
	var exitBt=new Ext.Toolbar.Button({
		text:'�˳�',
		iconCls : 'page_goto',
		handler:function()
		{		
			PicWin.hide();
			Ext.getCmp("fileTypeValue").setValue("");
		}
	});
	var displayAllPic = new Ext.Toolbar.Button({
		text:'ȫ����ʾ',
		iconCls : 'page',
		handler:function()
		{	DisplayAllTypes=true;
			// mygroup
			Ext.getCmp('mygroup').setValue({
			'comLic':true,
			'taxLic':true,
			'orgCode':true,
			'drugBusLic':true,
			'insBusLic':true,
			'insProLic':true,
			'legalComm':true,
			'saleServComm':true,
			'agentAuth':true,
			'qualityComm':true,
			'drugProLic':true,
			'gspLic':true,
			'insRegLic':true,
			'inletRegLic':true,
			'inletRLic':true,
			'drugRegLic':true,
			'salesLic':true,
			'vendorAgreement':true
			});
			Store.load({params:{'rowid':currVendorRowId,'type':sellist}}) ;		
			Store.on('load',function(){DisplayAllTypes=false;});
			
			return;

		}
	});
	
	var displayAllPicNot = new Ext.Toolbar.Button({
		text:'���ȫ����ʾ',
		iconCls : 'page',
		handler:function()
		{
			DisplayAllTypes=true;	
			Ext.getCmp('mygroup').setValue({
			'comLic':false,
			'taxLic':false,
			'orgCode':false,
			'drugBusLic':false,
			'insBusLic':false,
			'insProLic':false,
			'legalComm':false,
			'saleServComm':false,
			'agentAuth':false,
			'qualityComm':false,
			'drugProLic':false,
			'gspLic':false,
			'insRegLic':false,
			'inletRegLic':false,
			'inletRLic':false,
			'drugRegLic':false,
			'salesLic':false,
			'vendorAgreement':false
			});
			picView.getStore().removeAll();
			// Store.load({params:{'rowid':currVendorRowId,'type':sellist}}) ;			
			picView.refresh();
			DisplayAllTypes=false;
			initPic();
			}
	});
	
	var fileBt=new Ext.Toolbar.Button({
		text:'ͼƬ���¹鵵Ϊ:',
		iconCls : 'page_link',
		handler:function()
		{    
			var typeDesc=Ext.getCmp('fileTypeValue').getRawValue();
			var typeValue=Ext.getCmp('fileTypeValue').getValue();
			if (typeValue=='')
			{
				Msg.info("warning", '��ѡ�����¹鵵������!');
				Ext.getCmp('fileTypeValue').focus();
				return;
			}
			
			var arrpicr = picView.getSelectedRecords() // ����
			if ((!arrpicr)||(arrpicr.length==0))
			{
				Msg.info("warning", '��ѡ��ͼƬ!');
				return;
			}
			var picr=arrpicr[0];
			var row = picr.get("rowid");
			var picsrc =picr.get("picsrc");
			var typeName=picr.get("type");	
			
			if (typeDesc==typeName)
			{
				Msg.info('error','�뵱ǰ������ͬ����ѡ���������ʣ�')	;
				Ext.getCmp('fileTypeValue').setValue('');			
				Ext.getCmp('fileTypeValue').focus();
			}
			else
			{				
				Ext.Ajax.request({
					url:"dhcstm.apcvendoraction.csp?actiontype=UpdatePicInfo&rowid="+row+"&type="+typeValue,
					success:function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true')
						{
							Msg.info('success','ִ�гɹ�');						
							Store.reload();
						}
						else
						{
							Msg.info('error','ִ��ʧ��');
						}
					},
					failure:function()
					{
						Msg.info('error','ִ��ʧ��');
					}
				})
			}
		}
	});	
	
	  
	var fileCom=new Ext.form.ComboBox({
		id:'fileTypeValue',
	//	 typeAhead: true,
		 triggerAction: 'all',
//		lazyRender:true,
		mode: 'local',
		editable:false,
		store:new Ext.data.ArrayStore({
	        id: 0,
	        fields: [
	            'typeCode',
	            'typeDesc'
	        ],
	        data: [['comLic','����ִ��'],['taxLic','˰��ִ��'],['orgCode','��������'],['drugBusLic','ҩƷ��Ӫ���֤'],
				['insBusLic','��е��Ӫ���֤'],['insProLic','��е�������֤'],	  ['legalComm','����ί����'],['saleServComm','�ۺ�����ŵ��'],
				['agentAuth','������Ȩ��'],['qualityComm','������ŵ��'],['drugProLic','ҩƷ�������֤'],['gspLic','GSP��֤'],['insRegLic','��еע��֤'],
				['inletRegLic','����ע��ǼǱ�'],['inletRLic','����ע��֤'],['drugRegLic','ҩƷע������'],['salesLic','ҵ��Ա��Ȩ��'],['vendorAgreement','��Ӧ��Э��']]
				    }),
		width:200,
	    valueField: 'typeCode',
    	displayField: 'typeDesc'
	});
	
	var formPanel=new Ext.form.FormPanel({
			region:'north',
			height:120,
			baseCls:"x-plain",
			tbar : [displayAllPic,'-',displayAllPicNot,'-',bDelete,'-',fileBt,fileCom,'-',exitBt],
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
                {boxLabel: '������ŵ��', name: 'qualityComm',id:'qualityComm'},
                {boxLabel: 'GSP��֤', name: 'gspLic',id:'gspLic'},
				{boxLabel: 'ҵ��Ա��Ȩ��', name: 'salesLic',id:'salesLic'},
				{boxLabel: '��Ӧ��Э��', name: 'vendorAgreement',id:'vendorAgreement'},
                {boxLabel: '������Ȩ��', name: 'agentAuth',id:'agentAuth',hidden:true},
                {boxLabel: 'ҩƷ�������֤', name: 'drugProLic',id:'drugProLic',hidden:true},
                {boxLabel: '��еע��֤', name: 'insRegLic',id:'insRegLic',hidden:true},
                {boxLabel: '����ע��ǼǱ�', name: 'inletRegLic',id:'inletRegLic',hidden:true},
                {boxLabel: '����ע��֤', name: 'inletRLic',id:'inletRLic',hidden:true},
                {boxLabel: 'ҩƷע������', name: 'drugRegLic',id:'drugRegLic',hidden:true}
                
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
	
	
	var nextB=new Ext.Toolbar.Button({
		text:'���>>',
		handler:function()
		{
			var selArr=picView.getSelectedIndexes();
			
			if (selArr.length>0)
			{			 
				picView.select(selArr[0]+1,false);
				var d = detailPanel.body.dom;			
				var cnt=picView.getStore().getCount();	
				if (cnt>0)
				{
					var x=(d.scrollHeight/cnt)*(selArr[0]+1);
					if (d){
						d.scrollTop = x   ;
					}
				}
				
			}
			else
			{
				picView.select(0);
				if (d){
					d.scrollTop=0;
				}
			}
		}
	});
	
	var priorB=new Ext.Toolbar.Button({
		text:'<<��ǰ',
		handler:function()
		{
			var selArr=picView.getSelectedIndexes();
			
			if (selArr.length>0)
			{			 
				picView.select(selArr[0]-1,false);
				var d = detailPanel.body.dom;			
				var cnt=picView.getStore().getCount();	
				if (cnt>0)
				{
					var x=(d.scrollHeight/cnt)*(selArr[0]-1);
					if (d) {d.scrollTop= x   ;}
				}
			}
			else
			{
				picView.select(0);
				if (d) {d.scrollBottom=0;}
				
			}
		}
	});
	
	var detailPanel = new Ext.Panel({
		region:'west',
		minWidth:150,
		width:150,
		autoScroll : true,
		split:true,
		collapsible:true,
		//tbar : ['->',displayAllPic,'-',bDelete,'-',fileBt,fileCom,'-',exitBt],
		items : picView,
		bbar:new Ext.Toolbar({items:['->',priorB,'-',nextB]})
		
		 
	});
	
	var detailPanelOne = new Ext.Panel({
		region:'center',
		split:true
		,
		html:'<iframe id="pic" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		
	});
	
		
	if(!PicWin){ 
		PicWin = new Ext.Window({
			title : 'ͼƬ��Ϣ',
			//width : 820,
			width:gWinWidth,
			//height : 600,
			height: gWinHeight,
			maximizable:true,
			modal : true,
			closeAction:'hide',
			layout : 'border',
			 listeners:{
	   	      'show':function(){
	       	      Store.removeAll();
	       	      Ext.getCmp("fileTypeValue").setValue("");  
				  
	       	      Store.load({params:{'rowid':currVendorRowId,'type':sellist}});
				  displayAllPic.handler();
	   		 }
			 },
			
			items : [formPanel,detailPanel,detailPanelOne]
		});	
	}
	PicWin.show();
	function initPic()
	{
		var x=document.getElementById('pic') ;
		x.src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
	}
}