Ext.onReady(function(){
	var DHCMENUOBJECT = {};	//{show: boolean,menu: Ext.menu.Menu,button: Ext.Button} 2011-12-05
	var preSelectButton ; //ѡ�в˵���ѡ��״̬	2011-12-12
	Ext.BLANK_IMAGE_URL='../scripts_lib/ext3.2.1/resources/images/default/s.gif';         //add by wuqk 2010-09-06 default icon path
	Ext.QuickTips.init();
	var obj = new Object();
	var msgJObj = "";	//��Ϣ��ťjquery����
	var msgTimeoutQhanlder = "";
	//�����Ϣ��ť,��ʾ��Ϣ����
	var msgBtnClickHandler = function(){
		ShowDHCMessageCount();
		window.open("dhc.message.csp","dhcmessage","top=200,left=200px,width=960px,height=450px,center=yes,toolbar=no,menubar=no,resizable=yes,location=no,status=no,help=no");
		//top.frames["TRAK_main"].location = "dhc.message.csp";
		return false;
		//window.open("dhc.message.csp","dhcmessage","top=200,left=200px,width=760px,height=450px,center=yes,toolbar=no,menubar=no,resizable=yes,location=no,status=no,help=no");
		//return ;
	}
	//��ʾ��Ϣ����
	var ShowDHCMessageCount = function(){
		clearTimeout(msgTimeoutQhanlder);
		msgJObj = $("#DHCMessageBtn").find("button");
		if (msgJObj.length>0) {
			$.ajaxRunServerMethod({ 
				ClassName:"websys.DHCMessageDetailsMgr",MethodName:"GetNotReadMsgCount",UserId:session['LOGON.USERID']
			},function(rtn){
				if (rtn && rtn.Count>0){
					var messageBtn = msgJObj[0].outerHTML.replace("messagenull.gif","message.gif");
					var countDiv = "<span style='background-color:#8eb9f5;display:inline-block;padding:1px 0;color:#fff;width:14px;line-height:100%;text-align:center;margin-right:5px;'>"+rtn.Count+"</span>"
					msgJObj.parent().html(messageBtn+countDiv)
					msgJObj.bind("click",msgBtnClickHandler)
					msgTimeoutQhanlder = setTimeout(ShowDHCMessageCount,5*60*1000);	//����Ӳ�ѯһ����Ϣ����
					if (rtn.DCount>0){
						window.open("dhc.message.csp?LevelType=D","ImmedMessageWindow");
					}
				}
			})
		}else{
			//û���ҵ�Ԫ��,������extû��render���,���Ե�ȥ��ȥ��ѯ,���ǿ�����easyui��ͷ�˵�
			setTimeout(ShowDHCMessageCount,1000);
		}
	}
    var menuPanel = new Ext.Toolbar({
    	id:'menuPanel',
    	autoScroll : false,
    	region:"north",
    	height:35,
    	listeners:{afterrender: ShowDHCMessageCount}, //��ѯ��Ϣ
    	items:[]
    });
    
  	var url = "./epr.default.csp";
  	var lnkhref = "<iframe name='TRAK_main' width='100%' height='100%' src='" 
    			+ url + "' scrolling='auto' marginwidth='0' marginheight='0' frameborder='no' framespacing='0' />";
    var centerPanel = new Ext.Panel({
			id:'centerPanel',
    		region:"center",
    		border:false,
    		layout:"fit",
    		items:[{
    					id : 'panel_Center',
    					html : lnkhref
    			}
    		]
		});
	var southPanel = new Ext.Panel({
			id:'southPanel',
    		region:"south",
    		border:false,
    		//autoScroll:true,
    		//split:true,
    		//collapsible:true,   //�Զ�������ť 
    		layout:"fit",
    		height:0,
    		hidden:true,
    		items:[{
    					id : 'panel_South',
    					html : "<iframe name='TRAK_hidden' src='' scrolling='auto' marginwidth='0' marginheight='0' frameborder='no' framespacing='0' />"
    			}
    		]
		});
		
	obj.framemenu = new Ext.Viewport({
		id : 'framemenu'
		,layout : 'border'
		,rendTo : document.body
		
		,items:[
			menuPanel,
			centerPanel,
			southPanel
		]
	});
	//try{
		var menusJson = tkMakeServerCall("ext.websys.Menu","GetMainMenuJosn");
		//window.eval("var menuArray = " + menusJson);
		var menuArray = Ext.util.JSON.decode(menusJson);
		var toolItem;
		for(var intRow = 0; intRow < menuArray.length; intRow ++)
		{
			var menuObj = menuArray[intRow];
			var toolBtn = buildButton(menuObj);
			menuPanel.add(toolBtn);
			//���ӷָ�Ч��
	        if (intRow < menuArray.length - 1) {
	            var separatorItem = new Ext.Spacer({
	                cls: 'ToolBarSplit',
	                width: 2,
	                height: 25
	            });
	            menuPanel.add(separatorItem);
	        }
		}
		menuPanel.add({text:"�л�����",handler:changeloclogon})

		//message.gif
		menuPanel.add("->",{id:"DHCMessageBtn",icon:"../skin/default/images/message/messagenull.gif",text:"��Ϣ",handler:msgBtnClickHandler})
		//,'->',{icon:"../skin/default/images/loclogo/"+session['LOGON.CTLOCID']+".gif"}); 
		menuPanel.doLayout();
	//}
	//catch(e){
	//	Ext.Msg.alert('Information', e.message);
	//}
    
    //����Button
    function buildButton(menuObj){
    	var toolButton;
    	if (menuObj.leaf){
    		if (menuObj.href!=""){
    			menuObj.cls = menuObj.href;
    		}
    		toolButton = new Ext.Button({
				text : menuObj.text,
				icon: menuObj.icon,
				cls : menuObj.cls,
				listeners:{	"click": onItemClick}
			});
    	}else{
    		toolButton = new Ext.Button({
					text : menuObj.text,
					icon: menuObj.ico,
					cls : "",
					menu : [],
					listeners:{	"click":onItemClick, 'menushow':function(t,m){	//	Ϊ��ʵ�ֵ������ط�Ҳ�����ز˵�����
						DHCMENUOBJECT.show = true ;
						DHCMENUOBJECT.menu = m ;
						DHCMENUOBJECT.button = t;
						menuShowHandler(t,m);
					},'menuhide':function(t,m){
						DHCMENUOBJECT.show = false ;
						DHCMENUOBJECT.menu = null ;
						DHCMENUOBJECT.button = null;					
						menuShowHandler();
					}}
					
				});
				if (menuObj.children.length<1) toolButton.menu=null;
				for(var intRow = 0; intRow < menuObj.children.length; intRow ++)
				{
					var subMenuObj = menuObj.children[intRow];
					var menuItem = buildMenuItem(subMenuObj);
					toolButton.menu.add(menuItem);
				}
    	}
		return toolButton;
    }
    
  	//����˵���Ŀ
	function buildMenuItem(menuObj){
		var menuitem;
		if (menuObj.leaf){
			menuitem = new Ext.menu.Item({
				id: menuObj.id,
				text: menuObj.text,
	    		href: menuObj.href,
	    		hrefTarget: menuObj.hrefTarget,
	    		cls : menuObj.cls,
	    		icon: menuObj.icon,
				listeners:{	"click":onItemClick	}
			});
		}else{
			menuitem = new Ext.menu.Item({
				id: menuObj.id,
				text: menuObj.text,
	    		icon: menuObj.icon,
	    		menu : [],
				listeners:{	"click":onItemClick	}
			});
			for(var intRow = 0; intRow < menuObj.children.length; intRow ++)
			{
				var subMenuObj = menuObj.children[intRow];
				var menuItem = buildMenuItem(subMenuObj);
				menuitem.menu.add(menuItem);
			}
		}
		return menuitem;
	}	
  	function onItemClick(item,event){
  		var s = item.initialConfig.cls;
		if (s && s.indexOf("javascript")>-1){
			addSelectButtonClass(item,event);	//��bug ��javascript��֤��ͨ��ʱ,cls����Ӧ������
			//alert(s);
			window.eval(s);						
		}else{
			if (item.ctype.indexOf("Component")>0){
				if (s!=""){					
					addSelectButtonClass(item,event);
					top.frames["TRAK_main"].location = s;
				}
			}
			if(item.initialConfig.href){	//2011-12-12 ��ѡ����ʽ
				addSelectButtonClass(item,event);
			}
		}  		
  	}  	
	//Ϊ��ʵ�ֵ������ط�Ҳ�����ز˵�����
  	//2011-12-05 wanghc
	function menuShowHandler(){
		var fsdoc,len,i;
		var topf = top.frames["TRAK_main"];
		try{
			fsdoc = getFramesDoc(topf);
			len = fsdoc.length;
			if(DHCMENUOBJECT && DHCMENUOBJECT.show){
				Ext.EventManager.addListener(topf.document,"click",frameClickHandler);
				for(i = 0 ; i < len ; i++){
					Ext.EventManager.addListener(fsdoc[i],"click",frameClickHandler);
				}
			}else{
				Ext.EventManager.removeListener(topf.document,"click",frameClickHandler);
				for(i = 0 ; i < len ; i++){
					Ext.EventManager.removeListener(fsdoc[i],"click",frameClickHandler);
				}
			}
		}catch(e){}
		
	}	
	function getFramesDoc(f){
		var fsdoc = [];
		try{
			var fs = f.document.frames;
			var len = fs.length;
			for(var i = 0  ; i< len; i++){
				if(fs[i]){
					fsdoc.push(fs[i].document);	//runqian���� ��ܾ�����	
					if(fs[i].document.frames.length){				
						fsdoc = fsdoc.concat(getFramesDoc(fs[i]));
					}
				}
			}		
		}catch(e){
			
		}
		return fsdoc;
	}
  	//2011-12-05 wanghc	
	function frameClickHandler (){
		if(DHCMENUOBJECT && DHCMENUOBJECT.show ){
			DHCMENUOBJECT.menu.hide();
		}
	}
	function addSelectButtonClass(item,e){
		if(preSelectButton) {
			preSelectButton.removeClass('x-btn-click');
		}
		if(DHCMENUOBJECT && DHCMENUOBJECT.show ){
			DHCMENUOBJECT.button.addClass('x-btn-click');
			preSelectButton = DHCMENUOBJECT.button;
		}else{
			item.addClass('x-btn-click');
			preSelectButton = item;
		}
	}  	
});

