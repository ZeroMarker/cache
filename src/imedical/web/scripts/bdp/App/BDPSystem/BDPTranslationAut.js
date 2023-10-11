/// 名称: 功能元素授权
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2015-5-24
    
var ExecutabletreePanel;
var findExecutableGroupTree = function(e){
	var ExecutableDesc = Ext.getCmp('ExecutableDesc').getValue();				
	var loader = ExecutabletreePanel.getLoader();
	loader.baseParams.ExecutableDesc = ExecutableDesc;
	loader.load(ExecutabletreePanel.root);
}

var SubKey;
var SubKeyE;
var ObjectReference="1";
var ObjectType="G";
var firstclick="Y"

var EXECUTABLE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.BDPTranslation&pClassMethod=GetExecutableTreeJson";
var ITEM_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.BDPTranslation&pClassMethod=SaveAuthorizeData";

var DISABLE_ITEM_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.BDPTranslation&pClassMethod=GetDisableItemJson";
var ABLE_ITEM_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.BDPTranslation&pClassMethod=GetAbleItemJson";

var LANGUAGE_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.Authorize.BDPTranslation&pClassQuery=GetDataForCmb1";

	/** 授权页面面板 */
    var ExecutabletreeLoader = new Ext.tree.TreeLoader({
    		nodeParameter: "ParentID",
    		dataUrl: EXECUTABLE_ACTION_URL
    	}) ; //自动传node id
	var Executableroot = new Ext.tree.AsyncTreeNode({
			id:"ExecutablegroupTreeRoot",
			text:"授权页面列表",
			draggable:false
		}) ;
	ExecutabletreePanel = new Ext.tree.TreePanel({
		id:'ExecutabletreePanel',
		title:'授权页面',
		root:Executableroot,
		region:'west',
		loader:ExecutabletreeLoader,
		autoScroll:true,
		containerScroll: true,	
		//frame: true,
		split:true,
		minSize:175,
		maxSize:300,
		width:240,
		//margins:'0 0 0 0',
		//cmargins:'0 0 0 0',
		collapsible: true,
		//collapseMode: 'mini',
		rootVisible:false, //设为false将隐藏根节点
		tbar:[
			'检索',
			new Ext.form.TextField({
				id:'FindTreeText',
				width:150,
				emptyText:'请输入查找内容',
				enableKeyEvents: true,
				listeners:{
					keyup:function(node, event) {
						findByKeyWordFiler(node, event);
					},
					scope: this
				}
			}), '-', {
				text:'清空',
				iconCls:'icon-refresh',
				handler:Refresh = function(){clearFind();} //清除树过滤
			}
		],
	    listeners:{
	           "click":function(node,event) {
					SubKey = node.attributes.myExeCode;
					if (firstclick=="Y")
					{
						firstclick="N"
						setColor();
					}			
					if(ObjectReference == "") {Ext.Msg.alert("提示","请先选择授权类别!"); return;}
					
					if(typeof(SubKey)=="undefined") {
						SubKey="";
						Ext.getCmp("_multiselect3").fromStore.removeAll();
						Ext.getCmp("_multiselect3").toStore.removeAll();
					}else{
						SubKeyE=SubKey+"^"+Ext.getCmp("Language").getValue()
						clickevent();
					}	           
				}
	       }
	});
	var clickevent= function(){
			Ext.getCmp("_multiselect3").fromStore.removeAll();
			Ext.getCmp("_multiselect3").toStore.removeAll();
			Ext.getCmp("Language").setValue(Ext.getCmp("Language").getStore().getAt(0).get('CTLANCode'));;
			Ext.getCmp("_multiselect3").fromStore.load({params: {ObjectType:ObjectType,ObjectReference:ObjectReference,SubKey:SubKeyE}});	
			Ext.getCmp("_multiselect3").toStore.load({params: {ObjectType:ObjectType,ObjectReference:ObjectReference,SubKey:SubKeyE}});	
	}
	
	/** 菜单面板 */
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : DISABLE_ITEM_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'ID',
									mapping : 'ID',
									type : 'string'
								}, {
									name :'Name',
									mapping :'Name',
									type : 'string'
								}
						])
			});
	var ds1 = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : ABLE_ITEM_ACTION_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'ID',
							mapping : 'ID',
							type : 'string'
						}, {
							name :'Name',
							mapping :'Name',
							type : 'string'
						}
				])
	});
	//授权保存成功后授权页面菜单颜色改变
	function setColor(){
		
		//判断授权页面菜单是否授权,如果已授权则叶子节点显示为红色
		var IDJson = tkMakeServerCall("web.DHCBL.Authorize.BDPTranslation","GetItemPreferences",ObjectType,ObjectReference);
		if (IDJson=="") return;
		window.eval("var IDArray = " + IDJson);
		for(var i=0;i<IDArray.length;i++){
			var nodeAut="";
			nodeAut=Ext.getCmp("ExecutabletreePanel").getNodeById(IDArray[i].ID);
			if(nodeAut!=undefined){
				var str=nodeAut.text;
				if(str.indexOf("font")>-1){
					str=str.substring(str.lastIndexOf("'>")+2,str.indexOf("<\/"));
				}
				nodeAut.setText("<font color='red'>"+str+"</font>");
			}
		}
	}

	var TABPANEL = new Ext.Panel({
			title : '翻译功能配置',
			//width : 500,
			//height: 600,
			region:'center',
			frame:true,
			//bodyStyle : 'padding: 1px;',
			items : [{
				xtype : "itemselector",
				id    : "_multiselect3",
				fieldLabel : "ItemSelector",
				dataFields : ["ID", "Name"],
				fromStore   : ds,
				toStore     : ds1,
				toSortField : true,
				msWidth    : 300,
				msHeight   : 500,
				valueField   : "ID",
				displayField : "Name",
				toLegend     : "需要翻译字段",
				fromLegend   : "不需要翻译字段"
			}],
			tbar : ['翻译语言：',{
							xtype : 'combo',
							//pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							shadow:false,
							fieldLabel : '<font color=red></font>翻译语言',
							id :'Language',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('Language'),
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : LANGUAGE_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'CTLANRowId',mapping:'CTLANRowId'},
										{ name:'CTLANCode',mapping:'CTLANCode'},
										{name:'CTLANDesc',mapping:'CTLANDesc'} ]),
									listeners:{
											'load':function(){
												 Ext.getCmp('Language').setValue(this.getAt(0).get('CTLANCode'));
											}
										}
								}),
							mode : 'local',
							triggerAction : 'all',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'CTLANDesc',
							valueField : 'CTLANCode',
							listeners:{
								'select':function(){
										var SubKeyLang=SubKey+"^"+Ext.getCmp("Language").getValue()
										Ext.getCmp("_multiselect3").fromStore.load({params: {ObjectType:ObjectType,ObjectReference:ObjectReference,SubKey:SubKeyLang}});	
										Ext.getCmp("_multiselect3").toStore.load({params: {ObjectType:ObjectType,ObjectReference:ObjectReference,SubKey:SubKeyLang}});						
								}
								
							}
						},'-',{ 	
						text:'保存',
						icon:Ext.BDP.FunLib.Path.URL_Icon+'save.gif',
						handler:function() {
								if(ExecutabletreePanel){
									var Executablenode = ExecutabletreePanel.getSelectionModel().getSelectedNode();
									if(Executablenode){
										SubKey = Executablenode.attributes.myExeCode;
									}else{
										Ext.Msg.alert("提示","没有选中授权页面!");
										return ;
									}
								}
								if(typeof(SubKey)=="undefined"){
									Ext.Msg.alert("提示","请选择正确的授权页面!");
									return ;
								}
								var hasLanguage=Ext.getCmp('Language').getValue();
								if (hasLanguage=="") {
				    				Ext.Msg.show({ title : '提示', msg : '翻译语言不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
				          			return;
				    			}
								/*
								function ec(ss){ //去除空格
									return ss.replace(/[ ]/g,"");
								}
								var ss = Ext.getCmp("_multiselect3").getValue();
								var str = ec(ss);
								*/
								str="";
								function f(record){
									var ID = record.get("ID");
									if(ID) {
										if (str!="") str=str+",{";
										else str=str+"{";
										str=str+"ID:"+ID+"}"
									}
								}
								ds1.each(f);
								str="["+str+"]";
								var SubKeyLan=SubKey+"^"+Ext.getCmp("Language").getValue();
								//var	strAut = "{language:" + "'"+Ext.getCmp("Language").getValue() +"'"+ ",IDS:" + str + "}";
								Ext.Ajax.request({
									url:ITEM_SAVE_ACTION_URL,
									params: {ObjectType:ObjectType,ObjectReference:ObjectReference,Data:str,SubKey:SubKeyLan},
									success: function(resp,option){
												var rtn = resp.responseText.replace(/\r\n/g,"");
												try{var obj = Ext.decode(rtn);}catch(e){alert("操作失败!");return ;}
												if (obj.msg == "0") {
													Ext.Msg.show({
														title : '提示',
														msg : '保存成功!',
														minWidth : 150,
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK
													});
													//设置授权页面颜色
													setColor();
												}else {
													Ext.Msg.show({
														title : '提示',
														msg : '保存失败!<br>代码:' + obj.msg,
														minWidth : 150,
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK
													});
												}
											},
									failure: function(response, opts) {
												console.log('server-side failure with status code ' + response.status);
											},
									scope : this
								});
							}
						},'-',{
							text:"清空需要翻译字段",
							icon:Ext.BDP.FunLib.Path.URL_Icon+'bckdelete.gif',
							handler:function(){
								var i = Ext.getCmp("_multiselect3");
								i.reset.call(i);
							}
					}]
		});
		
	function getExecutabletreePanel(){
		return ExecutabletreePanel;
	}
	
	function getTABPANEL(){
		return TABPANEL;
	}

	
	
	/*******************************检索功能********************************/	
	var timeOutId = null;

	var treeFilter = new Ext.tree.TreeFilter(ExecutabletreePanel, {
		clearBlank : true,
		autoClear : true
	});

	// 保存上次隐藏的空节点
	var hiddenPkgs = [];
	var findByKeyWordFiler = function(node, event) {
		
		clearTimeout(timeOutId);// 清除timeOutId
		ExecutabletreePanel.expandAll();// 展开树节点
		// 为了避免重复的访问后台，给服务器造成的压力，采用timeOutId进行控制，如果采用treeFilter也可以造成重复的keyup
		timeOutId = setTimeout(function() {
			// 获取输入框的值
			var text = node.getValue();
			// 根据输入制作一个正则表达式，'i'代表不区分大小写
			var re = new RegExp(Ext.escapeRe(text), 'i');
			// 先要显示上次隐藏掉的节点
			Ext.each(hiddenPkgs, function(n) {
				n.ui.show();
			});
			hiddenPkgs = [];
			if (text != "") {
				treeFilter.filterBy(function(n) {
					// 只过滤叶子节点，这样省去枝干被过滤的时候，底下的叶子都无法显示
					var pinyin=Pinyin.getWordsCode(n.text)
					return !n.isLeaf() || re.test(n.text) || re.test(pinyin);
				});
				// 如果这个节点不是叶子，而且下面没有子节点，就应该隐藏掉
				ExecutabletreePanel.root.cascade(function(n) {
					if(n.id!='TreeRoot'){
						var pinyin=Pinyin.getWordsCode(n.text)
						if(!n.isLeaf() &&judge(n,re)==false&& (!re.test(n.text)||!re.test(pinyin))){
							hiddenPkgs.push(n);
							n.ui.hide();
						}
					}
				});
			} else {
				treeFilter.clear();
				return;
			}
		}, 500);
	}
	// 过滤不匹配的非叶子节点或者是叶子节点
	var judge =function(n,re){
		var str=false;
		n.cascade(function(n1){
			var pinyin=Pinyin.getWordsCode(n1.text)
			if(n1.isLeaf()){
				if(re.test(n1.text)||re.test(pinyin)){ str=true;return; }
			} else {
				if(re.test(n1.text)||re.test(pinyin)){ str=true;return; }
			}
		});
		return str;
	};
	// 清除树过滤
	var clearFind = function () {
		Ext.getCmp('FindTreeText').reset();
		ExecutabletreePanel.root.cascade(function(n) {
					if(n.id!='TreeRoot'){
						n.ui.show();
					}
			});
	}
	/*************************************************************/
