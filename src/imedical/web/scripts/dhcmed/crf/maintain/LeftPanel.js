var objLeftPanel = null;

function LeftMaintainPane() {
	
	var obj = new Object();    
	
	var objRootNode = new Ext.tree.TreeNode({
		leaf: false
		, text : "root"
		, id: "root"
		, draggable: false
	});
	
	obj.objFunctionTree = new Ext.tree.TreePanel({
		useArrows: true,
		autoScroll: true,
		animate: true,
		enableDD: true,
		containerScroll: true,
		border: false,
		rootVisible : false,
		title : "基础设置",
		collapsible : true,
		collapsed : true, //Modified By LiYang 2011-03-23
		root: objRootNode
	});
	
	obj.FormMaintain = ExtTool.StaticServerObject("DHCMed.CR.BO.FormMaintain");
	
	var CPWLogLocID=CPWLogLocID=session['LOGON.CTLOCID'];
	var SetPower=1;
	/*
	var LocPower=ExtTool.GetParam(window,"LocPower");
	if (LocPower==1) {
		SetPower=0;
	}else{
		if (tDHCMedMenuOper['admin']){
			SetPower=1;
		}else{
			SetPower=0;
		}
	}
	*/
	if (SetPower==1)
	{
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "字典定义"
				, id: "nodeDic"
				, draggable: false
			})
		);
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "函数定义"
				, id: "nodeFunc"
				, draggable: false
			})
		);
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "接口定义"
				, id: "nodeInterface"
				, draggable: false
			})
		);
		/*objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "新建报告 - SFXD"
				, id: "nodeTest"
				, draggable: false
			})
		);
				objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "新建报告 - SFXX"
				, id: "nodeTest4"
				, draggable: false
			})
		);
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "新建报告 - AZCEJBXX"
				, id: "nodeTest1"
				, draggable: false
			})
		);
		
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "打开报告 - 2"
				, id: "nodeTest2"
				, draggable: false
			})
		);*/
	}
	
	obj.objVerisonTreeLoader = new Ext.tree.TreeLoader({
	        nodeParameter: 'Arg1',
	        dataUrl: "./dhcmed.tree.csp",
	        baseParams: {
	            ClassName: 'DHCMed.CR.BO.FormMaintain',
	            QueryName: 'FormList',
	            //Arg2: (SetPower == 1 ? "" : CPWLogLocID),  //Modified By LiYang 2011-03-31 根据权限显示路径树
	            ArgCnt: 1
	        }
	});
	
	obj.objVerisonTree = new Ext.tree.TreePanel({
		useArrows: true,
		autoScroll: true,
		animate: true,
		enableDD: true,
		containerScroll: true,
		border: false,
		rootVisible: false,
		title: "表单定义",    
		loader: obj.objVerisonTreeLoader,
		collapsible : true,
		root: new Ext.tree.AsyncTreeNode({
			leaf: false
			, text: "root"
			, id: "-root"
			, draggable: false
		})
	});
	obj.objVerisonTree.getRootNode().expand();
    
    
	obj.pn = new Ext.Panel({
		width: "20%"
		,autoScroll : true
		, collapsible : true
		, region: "west"
		, layout: "form"
		, items:[
			obj.objFunctionTree,
			obj.objVerisonTree
		]
	});
	
	obj.objVerTreeContextMenu = new Ext.menu.Menu({
		minWidth : 80
		,items:[
			{
				id : "mnuNewForm",	
				text:'新建表单',
				icon:'',
				handler:function(){   //modified by maxiangping 2012-12-21
					if(obj.objSelNode == null)
						return;
					var arryArg = obj.objSelNode.id.split("-");
				//	Ext.Msg.alert("",obj.objSelNode.id);
						obj.ShowInNewTab("form",obj.objSelNode.text+"[新建表单]","./dhcmed.crf.editform.csp?FormID="+"&Type="+arryArg[2]);
						obj.refreshNode();
					}
			},{
				id : "mnuUpdaForm",	
				text:'修改表单',
				icon:'',
				handler:function(){ //modified by maxiangping 2012-12-21
					if(obj.objSelNode == null)
						return;
					var arryArg1 = obj.objSelNode.id.split("-");
					var arryArg2 = obj.objSelNode.parentNode.id.split("-");
				//	Ext.Msg.alert("",obj.objSelNode.id);
						obj.ShowInNewTab("form", obj.objSelNode.text+"[修改表单]" ,"./dhcmed.crf.editform.csp?FormID="+arryArg1[2]+"&Type="+arryArg2[2]);
				}
			}			
			,new Ext.menu.Separator({})
			,
			{
				id : "mnuNewLayout",	
				text:'新建版本',
				icon:'',
				handler:function(){
					if(obj.objSelNode == null)
						return;
					var arryArg = obj.objSelNode.id.split("-");
					
					var ret = obj.FormMaintain.NewVersion(arryArg[2]);
					
					if(ret > 0)
					{
						ExtTool.alert("提示", "新建版本成功!");
						//obj.objContentTree.setVisible(false);
						obj.ShowInNewTab("winLogo","Logo","");
						obj.refreshNode();
					}
					}
			},
			{
				id : "mnuSaveAs",	
				text:'复制为新版本',
				icon:'',
				handler:function(){
					if(obj.objSelNode == null)
						return;
					var arryArg = obj.objSelNode.id.split("-");
					
					var ret = obj.FormMaintain.SaveAs(arryArg[2]);
					
					if(ret > 0)
					{
						ExtTool.alert("提示", "版本复制成功!");
						//obj.objContentTree.setVisible(false);
						obj.ShowInNewTab("winLogo","Logo","");
						obj.refreshNode();
					}					
				}
			}

			,new Ext.menu.Separator({})

			,
			{
				id : "mnuPublishVer",
				text:'版本发布',
				icon:'../scripts/dhccpw/img/update.png',
				handler:function(){
					if(obj.objSelNode == null)
						return;
					var arryArg = obj.objSelNode.id.split("-");
					
					var ret = obj.FormMaintain.Published(arryArg[2]);
					
					if(ret > 0)
					{
						ExtTool.alert("提示", "版本发布成功!");
						//obj.objContentTree.setVisible(false);
						obj.ShowInNewTab("winLogo","Logo","");
						obj.refreshNode();
					}
				}
			}
			,
			{
				id : "mnuCanclePublishVer",
				text:'取消版本发布',
				icon:'../scripts/dhccpw/img/cancel.png',
				handler:function(){
					if(obj.objSelNode == null)
						return;
					var arryArg = obj.objSelNode.id.split("-");
					
					var ret = obj.FormMaintain.CanclePublished(arryArg[2]);
					
					if(ret > 0)
					{
						ExtTool.alert("提示", "取消版本发布成功!");
						//obj.objContentTree.setVisible(false);
						obj.ShowInNewTab("winLogo","Logo","");
						obj.refreshNode();
					}
				}
			}
			,
			{
				id : "mnuExport",
				text:' 导出',
				icon:'../scripts/dhccpw/img/update.png',
				handler:function(){
					if(obj.objSelNode == null)
						return;
					var arryArg = obj.objSelNode.id.split("-");
					var formService = ExtTool.StaticServerObject("DHCMed.CR.PO.Form"); 
					var objForm = formService.GetObjById(arryArg[2]);
					//alert(objForm.ESchema+"."+objForm.Type+"."+objForm.EName);
					var arrytxt = obj.objSelNode.text.split(" ")
					var dir = File_SelectDir();
					if (dir == "" ) return;
					//var s = SelectFiles(dir,function(rowIndex){alert(rowIndex);});
					//alert(s);
					//return;
					Ext.Ajax.request({
					   url: 'dhcmed.crf.export.csp',
					   params : {VerID:arryArg[2]},
					   success: function(response, opts) {
					      var content = response.responseText
					      var xmlfileName=dir + "\\" + objForm.ESchema + "." + objForm.Type + "." + objForm.EName + "_" + arrytxt[0] + "_" + arrytxt[2] + ".xml";
					      File_writeFile(xmlfileName,content);
					      alert("保存为：" + xmlfileName);
					   },
					   failure: function(response, opts) {
					      console.log('server-side failure with status code ' + response.status);
					   }
					});
				}
			}
			,
			{
				id : "mnuImport",
				text:' 导入',
				icon:'../scripts/dhccpw/img/update.png',
				handler:function(){
					if(obj.objSelNode == null)
						return;
					var arryArg = obj.objSelNode.id.split("-");
					//alert(arryArg);
					
					var path = File_SelectDir();
					if (path == "") return;
					File_selectFile(path,[".xml"],function(fileName){
						file = path + "\\" + fileName;
						var formService = ExtTool.StaticServerObject("DHCMed.CR.PO.Form"); 			
						var objForm = formService.GetStringById(arryArg[2]);
						/*var fileContent = File_readFile(file);
						var xmlData = new Object();
						xmlData["data"]=fileContent;
						var xmlLen = fileContent.length / 10240 + 1;
						for (var i = 0; i<xmlLen; i++){
							xmlData["data"+i] = fileContent.substring(i*10240, (i+1)*10240)
						}
						var formService = ExtTool.StaticServerObject("DHCMed.CR.PO.Form"); 			
						var objForm = formService.GetStringById(arryArg[2]);
						xmlData["formId"] = arryArg[2];
						xmlData["formInfo"] = Ext.encode(objForm);
						*/
						Ext.Ajax.request({
						   url: 'dhcmed.crf.import.csp',
						   params : {fileName:file}, //xmlData,  //,formId:arryArg[2],formInfo:objForm
						   success: function(response, opts) {
						      var content = response.responseText
						      //alert(content);
						      if(content>0)
						      {
						      	//alert("导入成功!");
						      	obj.ShowInNewTab("winLogo","Logo","");
										obj.refreshNode();
						      }
						   },
						   failure: function(response, opts) {
						      console.log('server-side failure with status code ' + response.status);
						   }
						});
					});
				}
			}

		]
	});
	obj.refreshNode = function(){
		obj.objVerisonTreeLoader.load(
							obj.objSelNode.parentNode,
							function()
							{
								this.expand();
							}
						);
		
		}
	obj.objFunctionTree.on("click", function(objNode){ 
		if(objNode == null)
			return;
		obj.SelNode = objNode;
		switch(objNode.id)
		{
			case "nodeDic":
				obj.ShowInNewTab(objNode.id, objNode.text ,"./dhcmed.crf.dictionary.csp");
				break;
			case "nodeFunc":
				obj.ShowInNewTab(objNode.id, objNode.text ,"./dhcmed.crf.function.csp");
				break;
			case "nodeInterface":
				obj.ShowInNewTab(objNode.id, objNode.text ,"./dhcmed.crf.interface.csp"); //modified by LiYang 2010-12-21 
				break;
		/*	case "nodeTest":
				//directrun("1||3","New","","");
				showForm({
					caption : 'New SFXD',
					formCode : 'DHCMed.CR.SFXD',
				//	formVerId : '2||1',
					PatientID : "139",
					EpisodeID:"12" //"277"
				//	,design : 1
				});
				break;
			case "nodeTest1":
				//directrun("1||3","New","","");
				showForm({
					caption : 'New AZCEJBXX',
					formCode : 'DHCMed.CR.AZCEJBXX',
					PatientID : "139"
					//params : "PatientID=1"
				});
				break;
			case "nodeTest2":
				//directrun("","Open","",2);
				showForm({
					caption : 'Open1',
					keyId : 1
				});
				break;
			case "nodeTest4":
				//directrun("1||3","New","","");
				showForm({
					caption : 'New SFXX',
					formCode : 'DHCMed.CR.SFXX',
				//	formVerId : '2||1',
					PatientID : "139",
					EpisodeID:"1"
				//	,design : 1
				});
				break;*/
			default:
				window.alert("未知菜单：" + objNode.text);
				break;
		}
	},obj);
	
	obj.objVerisonTree.on("contextmenu",function(objNode, eventObj){
		if(objNode == null)
			return;
		var arryParts = objNode.id.split("-");
		var objComp = null;
		objNode.select();
		switch(arryParts[1])
		{
			case "pro":
				Ext.getCmp("mnuNewForm").enable();
				Ext.getCmp("mnuNewLayout").disable();
				Ext.getCmp("mnuSaveAs").disable();
				Ext.getCmp("mnuPublishVer").disable();
				Ext.getCmp("mnuUpdaForm").disable(); 
				Ext.getCmp("mnuExport").disable();
				Ext.getCmp("mnuImport").disable();
				obj.objVerTreeContextMenu.showAt(eventObj.getXY());
				break;
			case "form":				
				Ext.getCmp("mnuNewForm").disable();  //disable();
				Ext.getCmp("mnuNewLayout").enable();
				Ext.getCmp("mnuSaveAs").disable();
				Ext.getCmp("mnuPublishVer").disable();
				Ext.getCmp("mnuUpdaForm").enable();
				Ext.getCmp("mnuExport").disable();
				Ext.getCmp("mnuImport").enable();
				obj.objVerTreeContextMenu.showAt(eventObj.getXY());
				break;
			case "ver":
				Ext.getCmp("mnuNewForm").disable();
				Ext.getCmp("mnuNewLayout").disable();
				Ext.getCmp("mnuSaveAs").enable();
				Ext.getCmp("mnuUpdaForm").disable();
				Ext.getCmp("mnuExport").enable();
				Ext.getCmp("mnuImport").disable();
				if(objNode.text.indexOf("未发布") == -1)
				{
					Ext.getCmp("mnuPublishVer").disable();
				}else{
					Ext.getCmp("mnuPublishVer").enable();
				}
				obj.objVerTreeContextMenu.showAt(eventObj.getXY());
				break;
			default:
				break;
		}
		//window.alert(objSelNode.id);
		obj.objSelNode = objNode;
	},obj);
	
	obj.objVerisonTree.on("dblclick",function(objNode){
		var arryParts = objNode.id.split("-");
		
		//判断当前版本是否已发布过，如果发布过则不能修改
		if(arryParts[3] == "1"){
			verReadOnly = "Y";
		}else{
			verReadOnly = "N";
		}
		//alert(verReadOnly);
		//只有到版本层次才显示临床路径树
		if(arryParts[1] == "ver"){
			
			var formService = ExtTool.StaticServerObject("DHCMed.CR.PO.Form"); 
			
			var objForm = formService.GetObjById(arryParts[2]);
			//alert(Ext.encode(objForm));
			var objForminfo = new FormInfo(objForm,arryParts[2]);
			objForminfo["VerReadOnly"] = verReadOnly;
			var url = "../service/dhcmedwebform/Default.htm?forminfo=";
			url += Ext.encode(objForminfo);
			//url += "&VerReadOnly=Y";
			
			//forminfo={ID:"1",ESchema:"DHCMed",Type:"CX",EName:"AZCEJBXX",CName:"%u5B89%u8D1ECE%u57FA%u672C%u4FE1%u606F"}
			//http://127.0.0.1/dthealth/web/service/dhcmedwebform/Default.htm?forminfo={ID:"1",ESchema:"DHCMed",Type:"CX",EName:"AZCEJBXX",CName:"%u5B89%u8D1ECE%u57FA%u672C%u4FE1%u606F"}
			obj.ShowInNewTab("",objNode.parentNode.text + " " + objNode.text,url);  //"./dhccpw.mrc.main.csp");
		}else{
			//obj.objContentTree.setVisible(false);
			//obj.objVerisonTree.setHeight(0); //Add By LiYang 2011-05-21 在显示版本树的时候才改变科室临床路径树的大小
		}
		
	},obj);
	
	//forminfo={ID:"1",ESchema:"DHCMed",Type:"CX",EName:"AZCEJBXX",CName:"%u5B89%u8D1ECE%u57FA%u672C%u4FE1%u606F"}
	//http://127.0.0.1/dthealth/web/service/dhcmedwebform/Default.htm?forminfo={ID:"1",ESchema:"DHCMed",Type:"CX",EName:"AZCEJBXX",CName:"%u5B89%u8D1ECE%u57FA%u672C%u4FE1%u606F"}
	obj.ShowInNewTab = function(windowName, caption, cspUrl, closeCallBack, objScope)
	{
			var objFrame = document.getElementById("crfFrame");
			var parentPanel = Ext.getCmp("crfMainTab");
			parentPanel.setTitle(caption);
			//parentPanel.doLayout();
			objFrame.src = cspUrl;
	}

	return obj.pn;
	
}


var FormInfo = function (objForm,VerID) {
    this.ID = objForm.RowID;
    this.EName = objForm.EName;
    this.CName = objForm.CName;
    this.Type = objForm.Type;
    this.ESchema = objForm.ESchema; 
    this.VerID = VerID; 
}

var directrun = function(VerID,caption,design,keyId){
	//alert(VerID);
	//var sUrl = fcpubdata.cspPath + "dhcmed.crf.directrun.csp?formid="+curFormId;
	if (design==undefined) {
		design=1;
	}
	var url = "dhcmed.crf.formshow.csp?design="+design+"&PatientID=1&keyId="+keyId+"&formVerId="+VerID;
	var win = new Ext.Window({
				title : caption, //'新页面',
				// maximizable : true,
				// maximized : true,
				width : document.body.clientWidth,  //800,
				height : document.body.clientHeight,  //600,
				// autoScroll : true,
				// bodyBorder : true,
				// draggable : true,
				isTopContainer : true,
				modal : true,
				resizable : true,
				contentEl : Ext.DomHelper.append(document.body, {		
						tag : 'iframe',		
						style : "border 0px none;scrollbar:true",		
						src : url,		
						height : "100%",		
						width : "100%"
						})
			})
	win.show();
}
