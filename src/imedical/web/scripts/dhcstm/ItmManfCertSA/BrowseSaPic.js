/**
 * 名称: 图片展示窗口
 * 
 * 描述: 编写者：xuchao 编写日期: 2014.5.22
 * 
 * @param {}
 *            store 中包含的字段 rowid 删除时对应的rowid picsrc 图片的路径
 * 
 * @param {}
 *            Fndelete 调用界面方法句柄，删除数据库中图片信息
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
ShowPicWindow = function(Store,sa, FnDelete) {
	// alert(sa);
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var ftpsrc = "http://" + gParam[5];

	Store.on('load',function(){
			var cnt=Store.getCount();
			if (cnt==0) 
			{
				var x=document.getElementById('pic') ;
				x.src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";	
			}
			else
			{
				picView.select(0);
				
			}	
		});	
//	alert(sellist);
	if (PicWin)
	{
		PicWin.sa=sa;
		PicWin.show();
		return;
	}
					
	var picTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<div style="padding:5px; height:130px; width:100px; float:left;" class="select_pic" >',
		'<img  class="pic" src="'
				+ ftpsrc
				+ '{picsrc}"style="height:100px; width:100px;"position: relative;>',
		'<p>{type}({vendesc})</p>',		
		'</div>', '</tpl>');

	var picTpl2 = new Ext.XTemplate(
		'<tpl for=".">',
		'<img  class="pic" src="'
				+ ftpsrc
				+ '{picsrc}"style="height:150px; width:160px;"position: relative;>',
		'<p>{type}({vendesc})</p>',		
		'</tpl>');		
	
	
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
		emptyText : '请选择要显示的资质图片',
		listeners : {
			'dblclick' : function(v, r) {
				var src = Store.getAt(r).get('picsrc')
				Ext.get("custom").dom.src = ftpsrc + src;
				// //获取图片的实际大小
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
					cus.resizeTo(1, 1);
					flag=0;
					PicWin.show();
				});
				var height = 600 ;// /设置默认高度
				var width = image.width / (image.height / height)  ;// /按照比例缩放
																	// 防止变形
				cus.resizeTo(width, height);
				PicWin.hide();
			},
			'selectionchange':function(v,arrpicr)
			{
				var arrpicr = v.getSelectedRecords(); // 数组
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
		text : '删除选中图片',
		tooltip : '删除选中图片',
		iconCls : 'page_delete',
		handler : function() {
			var arrpicr = picView.getSelectedRecords() // 数组
			if ((!arrpicr)||(arrpicr.length==0) ) {
				Msg.info("warning", '请选择要删除的图片!');
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
		text:'退出',
		iconCls : 'page_goto',
		handler:function()
		{		
			PicWin.hide();
		}
	});

	
	
	// var fileBt=new Ext.Toolbar.Button({
		// text:'图片重新归档为:',
		// iconCls : 'page_link',
		// handler:function()
		// {
			// var typeDesc=Ext.getCmp('fileTypeValue').getRawValue();
			// var typeValue=Ext.getCmp('fileTypeValue').getValue();
			// if (typeValue=='')
			// {
				// Msg.info("warning", '请选择重新归档的类型!');
				// Ext.getCmp('fileTypeValue').focus();
				// return;
			// }
			
			// var arrpicr = picView.getSelectedRecords() // 数组
			// if ((!arrpicr)||(arrpicr.length==0))
			// {
				// Msg.info("warning", '请选择图片!');
				// return;
			// }
			// var picr=arrpicr[0];
			// var row = picr.get("rowid");
			// var picsrc =picr.get("picsrc");
			// var typeName=picr.get("type");	
			
			// if (typeDesc==typeName)
			// {
				// Msg.info('error','与当前资质相同，请选择其他资质！')	;
				// Ext.getCmp('fileTypeValue').setValue('');			
				// Ext.getCmp('fileTypeValue').focus();
			// }
			// else
			// {				
				// Ext.Ajax.request({
					// url:"dhcstm.apcvendoraction.csp?actiontype=UpdatePicInfo&rowid="+row+"&type="+typeValue,
					// success:function(result, request){
						// var jsonData = Ext.util.JSON.decode( result.responseText );
						// if (jsonData.success=='true')
						// {
							// Msg.info('success','执行成功');						
							// Store.reload();
						// }
						// else
						// {
							// Msg.info('error','执行失败');
						// }
					// },
					// failure:function()
					// {
						// Msg.info('error','执行失败');
					// }
				// })
			// }
		// }
	// });	
	
	
	
	var nextB=new Ext.Toolbar.Button({
		text:'向后>>',
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
					d.scrollTop = x   ;
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
		text:'<<向前',
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
					d.scrollTop= x   ;
				}
			}
			else
			{
				picView.select(0);
				d.scrollBottom=0;
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
	var zoom=new Ext.Toolbar.Button({	
		text:'ssssssssss',
		handler:function(){
			var img=document.getElementById("pic");
			//alert(img);	
			//img.width=150;	  
			   img.width= detailPanelOne.getWidth()-50;   
	 img.height= detailPanelOne.getHeight()-50;
		}
		
	})
		
	var detailPanelOne = new Ext.Panel({
		region:'center',
		split:true
		,
		html:'<img id="pic" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		,tbar:new Ext.Toolbar({})
	});
	
	var closeBt=new Ext.Button({
		text:'关闭'
		,
		iconCls:'page_delete',
		handler:function(){
			Ext.getCmp('saPicWin').hide();
		}
	});
	if(!PicWin){ 
		PicWin = new Ext.Window({
			title : '图片信息',
			id:'saPicWin',
			//width : 820,
			width:gWinWidth,
			//height : 600,
			height: gWinHeight,
			maximizable:true,
			modal : true,
			tbar:[closeBt],
			closeAction:'hide',
			layout : 'border',
			sa:sa,
			 listeners:{
	   	      'show':function(){
	       	    
				  Store.removeAll();
				  // alert(this.sa);
	       	      Store.load({params:{'sa':this.sa}});
	   		 }
			 },
			
			items : [detailPanel,detailPanelOne]
		});	
		PicWin.show();
	}
	
}