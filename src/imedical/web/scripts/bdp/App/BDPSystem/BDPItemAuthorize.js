/// 名称: 功能元素授权
/// 编写者: 基础数据平台组-李森
/// 编写日期: 2013-5-4
    
var ExecutabletreePanel;
var findExecutableGroupTree = function(e){
	var ExecutableDesc = Ext.getCmp('ExecutableDesc').getValue();				
	var loader = ExecutabletreePanel.getLoader();
	loader.baseParams.ExecutableDesc = ExecutableDesc;
	loader.load(ExecutabletreePanel.root);
}

var SubKey;
var SaveSubKey;

var EXECUTABLE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.Executables&pClassMethod=GetExecutableTreeJson";
var ITEM_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.Executables&pClassMethod=SaveAuthorizeData";

var ABLE_ITEM_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.Executables&pClassMethod=GetAbleItemJson";
var DISABLE_ITEM_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.Executables&pClassMethod=GetDisableItemJson";

//var initComp = function(){
	
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
		rootVisible:false //设为false将隐藏根节点	
		/*tbar: ['查找',new Ext.form.TwinTriggerField({
							widht:280,
							id:'ExecutableDesc',
							enableKeyEvents:true,
							trigger1Class: 'x-form-clear-trigger',
							trigger2Class: 'x-form-search-trigger',
							onTrigger1Click: function(e){
								this.setValue("");
								findExecutableGroupTree();
							},
							onTrigger2Click: findExecutableGroupTree
						})
			]*/
	});
	
	
	/** 菜单面板 */
	var ds = new Ext.data.Store({
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
	var ds1 = new Ext.data.Store({
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
	//授权保存成功后授权页面菜单颜色改变
	function setColor(){
		//取消颜色
		var f  = function(node) {
			var str=node.text;
			if(str.indexOf("font")>-1){
				str=str.substring(str.indexOf("'>")+2,str.indexOf("</"));
			}
			node.setText(str);
		}
		Ext.getCmp("ExecutabletreePanel").getRootNode().cascade(f);
		
		//判断授权页面菜单是否授权,如果已授权则叶子节点显示为红色
		var IDJson = tkMakeServerCall("web.DHCBL.Authorize.Executables","GetItemPreferences",ObjectType,ObjectReference);
		if (IDJson=="") return;
		window.eval("var IDArray = " + IDJson);
		for(var i=0;i<IDArray.length;i++){
			var nodeAut="";
			nodeAut=Ext.getCmp("ExecutabletreePanel").getNodeById(IDArray[i].ID);
			if(nodeAut){
				nodeAut.setText("<font color='red'>"+nodeAut.text+"</font>");
			}
		}
	}
	var TABPANEL = new Ext.Panel({
			title : '功能元素授权',
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
				msWidth    : 250,
				msHeight   : 480,
				valueField   : "ID",
				displayField : "Name",
				toLegend     : "不可编辑元素",
				fromLegend   : "可编辑元素"
			}],
			tbar : [{ 	text:'保存',
						icon:Ext.BDP.FunLib.Path.URL_Icon+'save.gif',
						handler:function() {
								if(ExecutabletreePanel){
									var Executablenode = ExecutabletreePanel.getSelectionModel().getSelectedNode();
									if(Executablenode){
			
										
									}else{
										Ext.Msg.alert("提示","没有选中授权页面!");
										return ;
									}
								}
								if(typeof(SubKey)=="undefined"){
									Ext.Msg.alert("提示","请选择正确的授权页面!");
									return ;
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
								//if(str!="") 
								str="["+str+"]";
								//alert(str);return;
								Ext.Ajax.request({
									url:ITEM_SAVE_ACTION_URL,
									params: {ObjectType:ObjectType,ObjectReference:ObjectReference,Data:str,SubKey:SaveSubKey},
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
							text:"清空不可编辑元素",
							icon:Ext.BDP.FunLib.Path.URL_Icon+'bckdelete.gif',
							handler:function(){
								var i = Ext.getCmp("_multiselect3");
								i.reset.call(i);
							}
					},'->',helphtmlbtn]
		});
		
	function getExecutabletreePanel(){
		return ExecutabletreePanel;
	}
	
	function getTABPANEL(){
		return TABPANEL;
	}

	var clickevent= function(){
			Ext.getCmp("_multiselect3").fromStore.load({params: {ObjectType:ObjectType,ObjectReference:ObjectReference,SubKey:SubKey}});	
			Ext.getCmp("_multiselect3").toStore.load({params: {ObjectType:ObjectType,ObjectReference:ObjectReference,SubKey:SubKey}});	
	}
	if(ExecutabletreePanel){
		ExecutabletreePanel.on("click",function (node, e){
			if(ObjectReference == "") {Ext.Msg.alert("提示","请先选择授权类别!"); return;}
			SubKey = node.attributes.id;
			var HISUIFlag=tkMakeServerCall("web.DHCBL.CT.FunctionalElement","HaveItems",node.attributes.id)
			if (HISUIFlag=="Y")
			{
				SaveSubKey=SubKey = node.attributes.id;
			}
			else
			{
				SaveSubKey = node.attributes.myExeCode;
			}

			if(typeof(SubKey)=="undefined") {
				SubKey="";
				Ext.getCmp("_multiselect3").fromStore.removeAll();
				Ext.getCmp("_multiselect3").toStore.removeAll();
			}else{
				clickevent();
			}
		},this,{stopEvent:true});
	}
	/*
	// 功能查找“回车”事件
	Ext.getCmp("ExecutableDesc").on("keypress",function(t,e){
		if(e.getKey() == e.ENTER){
			findExecutableGroupTree();
		}
	});
	*/
//};




//var init = function(){
//	//initComp();
//	initListener();
//};
//Ext.onReady(init);