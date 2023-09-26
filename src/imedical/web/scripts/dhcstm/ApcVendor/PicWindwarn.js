/**
 * 名称: 图片展示窗口
 * 
 * 描述: 编写者：xuchao 编写日期: 2014.5.22
 * 
 * @param {}
 *            store 中包含的字段 rowid 删除时对应的rowid picsrc 图片的路径
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
	GetParam(); // 初始化参数配置
}

var sellist="";
////flag 判断是否清空store和formpanel
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
		emptyText : '请选择要显示的资质图片',
		listeners : {
			'dblclick' : function(v, r) {
				var src = Store.getAt(r).get('picsrc')
				Ext.get("custom").dom.src = ftpsrc + src;
				//获取图片的实际大小
				var image = new Image();
				image.src = ftpsrc + src;
				document.body.appendChild(image); //加载图片
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
				var height = 600 ;// /设置默认高度
				var width = image.width / (image.height / height)  ;// /按照比例缩放
																	// 防止变形
				cus.resizeTo(width, height);
				PicWin.hide();
			}

		}

	})

	var exitBt=new Ext.Toolbar.Button({
		text:'退出',
		iconCls : 'page_goto',
		handler:function()
		{		
			PicWin.hide();
		}
	});
	var displayAllPic = new Ext.Toolbar.Button({
		text:'显示全部',
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
            fieldLabel: '选择要显示的资质',
            columns: 5,
            items: [
                {boxLabel: '工商执照', name: 'comLic',id:'comLic'},
                {boxLabel: '税务执照', name: 'taxLic',id:'taxLic'},
                {boxLabel: '机构代码', name: 'orgCode',id:'orgCode'},
                {boxLabel: '药品经营许可证', name: 'drugBusLic',id:'drugBusLic'},
                {boxLabel: '器械经营许可证', name: 'insBusLic',id:'insBusLic'},
                {boxLabel: '器械生产许可证', name: 'insProLic',id:'insProLic'},
                {boxLabel: '法人委托书', name: 'legalComm',id:'legalComm'},
                {boxLabel: '售后服务承诺书', name: 'saleServComm',id:'saleServComm'},
                {boxLabel: '代理授权书', name: 'agentAuth',id:'agentAuth'},
                {boxLabel: '质量承诺书', name: 'qualityComm',id:'qualityComm'},
                {boxLabel: '药品生产许可证', name: 'drugProLic',id:'drugProLic'},
                {boxLabel: 'GSP认证', name: 'gspLic',id:'gspLic'},
                {boxLabel: '器械注册证', name: 'insRegLic',id:'insRegLic'},
                {boxLabel: '进口注册登记表', name: 'inletRegLic',id:'inletRegLic'},
                {boxLabel: '进口注册证', name: 'inletRLic',id:'inletRLic'},
                {boxLabel: '药品注册批件', name: 'drugRegLic',id:'drugRegLic'}
                
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
			title : '图片信息',
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