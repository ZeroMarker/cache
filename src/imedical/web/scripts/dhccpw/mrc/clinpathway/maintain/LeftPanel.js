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
		title : "基础信息维护",
		collapsible : true,
		collapsed : true, //Modified By LiYang 2011-03-23
		root: objRootNode
	});

	var CPWLogLocID=session['LOGON.CTLOCID'];
	var SetPower=1;
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
	if (SetPower==1)
	{
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "基础参数设置"
				, id: "基础参数设置"
				, draggable: false
			})
		);
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "临床路径定义"
				, id: "临床路径定义"
				, draggable: false
			})
		);
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "路径类型"
				, id: "路径类型"
				, draggable: false
			})
		);
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "项目大类"
				, id: "项目大类"
				, draggable: false
			})
		);
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "项目子类"
				, id: "项目子类"
				, draggable: false
			})
		);
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "变异类型"
				, id: "变异类型"
				, draggable: false
			})
		);
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "变异原因"
				, id: "变异原因"
				, draggable: false
			})
		);
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "科室常用路径"
				, id: "科室常用路径"
				, draggable: false
			})
		);
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "基础字典"
				, id: "基础字典"
				, draggable: false
			})
		);
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "函数库"
				, id: "函数库"
				, draggable: false
			})
		);
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "关联项目"
				, id: "关联项目"
				, draggable: false
			})
		);
		
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "导入路径表单"
				, id: "导入路径表单"
				, draggable: false
			})
		);
		
		objRootNode.appendChild(
			new Ext.tree.TreeNode({
				leaf: false
				, text: "关联医嘱批处理"
				, id: "关联医嘱批处理"
				, draggable: false
			})
		);
	}
	
	obj.objVerisonTreeLoader = new Ext.tree.TreeLoader({
	        nodeParameter: 'Arg1',
	        dataUrl: "./dhccpw.tree.csp",
	        baseParams: {
	            ClassName: 'web.DHCCPW.MRC.PathWayQry',
	            QueryName: 'QryLocPathVer',
	            Arg2: (SetPower == 1 ? "" : CPWLogLocID),  //Modified By LiYang 2011-03-31 根据权限显示路径树
	            ArgCnt: 2
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
		//title: "科室路径维护",
		title: "路径列表",    //by wuqk 2011-07-21
		loader: obj.objVerisonTreeLoader,
		collapsible : true,
		//height : 200, //Modify By LiYang 2011-03-23 固定版本树高度  //Modified By LiYang 2011-05-21  初始不限定高度
		root: new Ext.tree.AsyncTreeNode({
			leaf: false
			, text: "root"
			, id: "-root"
			, draggable: false
		})
	});
	obj.objVerisonTree.getRootNode().expand();
    
	obj.objContentTreeLoader = new Ext.tree.TreeLoader({
		nodeParameter: 'Arg1',
		dataUrl: "./dhccpw.tree.csp",
		baseParams: {
			ClassName: 'web.DHCCPW.MRC.PathWayQry',
			QueryName: 'QryPathContent',
			Arg2 : 1,
			ArgCnt: 2
		}
	});

	obj.objContentTree = new Ext.tree.TreePanel({
		useArrows: true,
		autoScroll: true,
		animate: true,
		enableDD: true,
		containerScroll: true,
		border: false,
		rootVisible: true,
		//height: 200,
		title: "路径表单维护",
		loader: obj.objContentTreeLoader,
		collapsible : true,
		root: new Ext.tree.AsyncTreeNode({
			leaf: false
			,text: "root"
			,id: "-root"
			,draggable: false
			,icon : '../images/websys/home.gif'
		})
        });
        obj.objContentTree.setVisible(false);
    
	obj.pn = new Ext.Panel({
		width: "25%"
		,autoScroll : true
		, collapsible : true
		, region: "west"
		, layout: "form"
		, items:[
			obj.objFunctionTree,
			obj.objVerisonTree,
			obj.objContentTree
		]
	});
	
	obj.objVerTreeContextMenu = new Ext.menu.Menu({
		minWidth : 80
		,items:[
			{
				id : "mnuPublishVer",
				text:'版本发布',
				icon:'../scripts/dhccpw/img/update.png',
				handler:function(){
					if(obj.objSelNode == null)
						return;
					var arryArg = obj.objSelNode.id.split("-");
					var ClinPathWaysSrv = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv"); 
					//
					var flg = ClinPathWaysSrv.cntEpStepItem(arryArg[0]);
					var count = flg.split("^"), TipInfo = "";
					if (count[0]<1) { TipInfo = TipInfo + "阶段、"; }
					if (count[1]<1) { TipInfo = TipInfo + "步骤、"; }
					if (TipInfo!="") {
						TipInfo = TipInfo.substring(0, TipInfo.length-1);
						ExtTool.alert("提示", "未维护["+TipInfo+"],不允许发布!");
						return;
					}
					//
					var ret = ClinPathWaysSrv.PublishPathWayVersion(
						arryArg[0],
						session['LOGON.USERID']
						);
					if(ret > 0)
					{
						ExtTool.alert("提示", "临床路径版本发布成功!");
						obj.objContentTree.setVisible(false);
						obj.ShowInNewTab("winLogo","Logo","./dhccpw.mrc.main.csp");
						objLeftPanel.objVerisonTreeLoader.load(
							obj.objSelNode.parentNode,
							function()
							{
								this.expand();
							}
						);
					}
				}
			}
			//**************************************************************
			//update by zf 20111207 开放发布版本
			,{
				id : "mnuUpdoPublishVer",
				text:'开放发布版本',
				icon:'../scripts/dhccpw/img/update.png',
				handler:function(){
					if(obj.objSelNode == null)
						return;
					var arryArg = obj.objSelNode.id.split("-");
					var ClinPathWaysSrv = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv"); 
					var ret = ClinPathWaysSrv.UpdoPublishVersion(
						arryArg[0],
						session['LOGON.USERID']
					);
					if(ret > 0)
					{
						ExtTool.alert("提示", "开放发布版本成功!");
						obj.objContentTree.setVisible(false);
						obj.ShowInNewTab("winLogo","Logo","./dhccpw.mrc.main.csp");
						objLeftPanel.objVerisonTreeLoader.load(
							obj.objSelNode.parentNode,
							function()
							{
								this.expand();
							}
						);
					}
				}
			}
			//**************************************************************
			,new Ext.menu.Separator({})
			,{
				id : "mnuNewVer",
				text:'新建版本',
				icon:'../scripts/dhccpw/img/new.gif',
				handler:function(){
					if (obj.objSelNode == null) return;
					var args = obj.objSelNode.id.split("-");
					//**************************************************
					//update by zf 20110301
					var CPWDicID=args[0];
					var ClinPathWaysSrv = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv");
					var flg=ClinPathWaysSrv.GetNotPubVer(CPWDicID,"");
					if (flg>0){
						ExtTool.alert("提示", "此路径存在未发布版本,不允许新建版本!");
						return;
					}
					//**************************************************
					var strTmp = "" + "^" + CPWDicID + "^^^^^^^";
					var DHCMRCClinPathWays = ExtTool.StaticServerObject("web.DHCCPW.MRC.CliPathWay");
					try {
						var ret = DHCMRCClinPathWays.Update(strTmp);
						if(ret > 0){
							obj.objContentTree.setVisible(false);
							obj.ShowInNewTab("winLogo","Logo","./dhccpw.mrc.main.csp");
							obj.objVerisonTreeLoader.load(
								obj.objSelNode,
								function(){
									this.expand();
								}
							);
							ExtTool.alert("提示", "保存成功！");
						}
					} catch(e) {
						ExtTool.alert("错误", e.description, Ext.MessageBox.OK, Ext.MessageBox.ERROR);
					}
				}
			}
			,{
				id : "mnuCopyVer",
				text:'复制版本',
				icon:'../scripts/dhccpw/img/save.gif',
				handler:function(){
					if (obj.objSelNode == null) return;
					var ClinPathWaysSrv = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv");
					//**************************************************
					//update by zf 20110301
					var CPWID=obj.objSelNode.id.split("-")[0];
					var flg=ClinPathWaysSrv.GetNotPubVer("",CPWID);
					if (flg>0){
						ExtTool.alert("提示", "此路径存在未发布版本,不允许复制版本!");
						return;
					}
					//**************************************************
					var ret = ClinPathWaysSrv.CopyPathWayVersion(CPWID);
					if(ret > 0)
					{
						obj.objContentTree.setVisible(false);
						obj.ShowInNewTab("winLogo","Logo","./dhccpw.mrc.main.csp");
						var objParentNode = obj.objSelNode.parentNode
						obj.objVerisonTreeLoader.load(
							objParentNode,
							function(){
								this.expand();
							}
						);
						ExtTool.alert("提示","复制成功！!");
					}
				}
			}
			,{//add by wuqk 2011-10-26 ----------------begin---------
				id : "mnuSaveAs",
				text:'另存为新路径',
				icon:'../scripts/dhccpw/img/save.gif',
				handler:function(){
					if (obj.objSelNode == null) return;
					var ClinPathWaysSrv = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv");
					var CPWID=obj.objSelNode.id.split("-")[0];
					//**************************************************
					ExtTool.prompt("另存为","请输入新路径名称",function(btn, newName){
						if (newName=="") return;
						ExtTool.alert("",newName);
						var ret = ClinPathWaysSrv.SaveAsNew(CPWID,newName);
						if(ret > 0)
						{
							obj.objContentTree.setVisible(false);
							obj.ShowInNewTab("winLogo","Logo","./dhccpw.mrc.main.csp");
							var objParentNode = obj.objSelNode.parentNode.parentNode
							obj.objVerisonTreeLoader.load(
								objParentNode,
								function(){
									this.expand();
								}
							);
							ExtTool.alert("提示","另存成功！!");
						}else{
							if (ret=='-101') {
								ExtTool.alert("错误提示","存在同名的路径!");
							}else{
								ExtTool.alert("error",ret);
							}
						}
					});
				}
			}//add by wuqk 2011-10-26 ----------------end---------
			,{
				id : "mnuDeleteVer",
				text:'删除版本',
				icon:'../scripts/dhccpw/img/delete.gif',
				handler:function(){
				 	Ext.MessageBox.confirm('删除', '确定删除这个版本?', function(btn,text){
						if(btn=='yes'){
							var DHCMRCClinPathWays = ExtTool.StaticServerObject('web.DHCCPW.MRC.CliPathWay');
							var deleteVal=DHCMRCClinPathWays.Delete(obj.objSelNode.id.split("-")[0]);
							//*******	Modified by zhaoyu 2013-01-04 临床路径维护--路径版本控制-对已发布的版本，不允许删除；提示 178
							var CPWVerUserDR=DHCMRCClinPathWays.GetObjById(obj.objSelNode.id.split("-")[0])	//	发布人DR
							if (CPWVerUserDR!=""){
								Ext.MessageBox.show({
									title: 'Failed',
									msg: '发布过的版本不允许删除！',
									buttons: Ext.MessageBox.OK,
									icon:Ext.MessageBox.ERROR
								});	
							}else if(deleteVal > 0){
							//*******
							//if(deleteVal > 0){
								obj.objContentTree.setVisible(false);
								obj.ShowInNewTab("winLogo","Logo","./dhccpw.mrc.main.csp");
								var objParentNode = obj.objSelNode.parentNode.parentNode
								obj.objVerisonTreeLoader.load(
									objParentNode,
									function(){
										this.expand();
									}
								);
							}else{
								Ext.MessageBox.show({
									title: 'Failed',
									msg: '删除失败!',
									buttons: Ext.MessageBox.OK,
									icon:Ext.MessageBox.ERROR
								});	
							}
						}
				       });
				}
			},{//add by wuqk 2011-11-01
				id : "mnuExport", 
				text:'关联医嘱导出',
				icon:'../scripts/dhccpw/img/export.png',
				handler:function(){
					if(obj.objSelNode == null)
						return;
					var CPWID=obj.objSelNode.id.split("-")[0];
					var CPWDesc=obj.objSelNode.parentNode.text+"("+obj.objSelNode.text+")";
					ExportDataToExcel(CPWID,CPWDesc);
				}
			}
			,{
				id : "mnuExportForm", 
				text:'表单导出',
				icon:'../scripts/dhccpw/img/export.png',
				handler:function(){
					if(obj.objSelNode == null)
						return;
					var CPWID=obj.objSelNode.id.split("-")[0];
					var CPWDesc=obj.objSelNode.parentNode.text+"("+obj.objSelNode.text+")";
					ExportPathWayForm(CPWID,CPWDesc);
				}
			}
			,{
				id : "mnuExportNewForm", 
				text:'新版表单导出',
				icon:'../scripts/dhccpw/img/export.png',
				handler:function(){
					if(obj.objSelNode == null)
						return;
					var CPWID=obj.objSelNode.id.split("-")[0];
					var CPWDesc=obj.objSelNode.parentNode.text+"("+obj.objSelNode.text+")";
					ExportPathWayFormNew(CPWID,CPWDesc);
				}
			}					
			,new Ext.menu.Separator({})
			/* 临床路径维护监控条件 标准版中不使用 屏蔽菜单
			,{
				id : "mnuCPWRule",
				text:'监控维护',
				icon:'../scripts/dhccpw/img/update.png',
				handler:function(){
					if(obj.objSelNode == null)
						return;
					var arryArg = obj.objSelNode.id.split("-");
					var CPWDesc=obj.objSelNode.parentNode.text+"("+obj.objSelNode.text+")";
					obj.ShowInNewTab("WinRules", "【监控维护】" + CPWDesc,"./dhccpw.mrc.cpwrule.csp?CPWRowID=" + arryArg[0]);
				}
			}*/
			,{
				id : "mnuCPWForm",
				text:'表单展现',
				icon:'../scripts/dhccpw/img/update.png',
				handler:function(){
					if(obj.objSelNode == null)
						return;
					var arryArg = obj.objSelNode.id.split("-");
					var CPWDesc=obj.objSelNode.parentNode.text+"("+obj.objSelNode.text+")";
					obj.ShowInNewTab("WinForm", "【表单展现】" + CPWDesc,"./dhccpw.mrc.formshow.csp?CPWRowID=" + arryArg[0]);
				}
			}
		]
	});
	
	obj.objFunctionTree.on("click", function(objNode){  //update by zf 20120208 dblclick->click
		if(objNode == null)
			return;
		obj.SelNode = objNode;
		switch(objNode.id)
		{
			case "基础参数设置":
				obj.ShowInNewTab("基础参数设置", objNode.id ,"./dhccpw.mrc.baseconfig.csp");
				break;
			case "临床路径定义":
				obj.ShowInNewTab("临床路径定义", objNode.id ,"./dhccpw.mrc.pathdicedit.csp"); //modified by LiYang 2010-12-21 
				break;
			case "路径类型":
				obj.ShowInNewTab("路径类型", objNode.id ,"./dhccpw.mrc.pathtypeedit.csp");	
				break;
			case "项目大类":
				obj.ShowInNewTab("项目大类", objNode.id ,"./dhccpw.mrc.stepitemcatedit.csp");	
				break;
			case "项目子类":
				obj.ShowInNewTab("项目子类", objNode.id ,"./dhccpw.mrc.stepitemsubcatedit.csp");
				break;
			case "变异类型":
				obj.ShowInNewTab("变异类型", objNode.id ,"./dhccpw.mrc.varcategedit.csp");
				break;
			case "变异原因":
				obj.ShowInNewTab("变异原因", objNode.id ,"./dhccpw.mrc.varreasonedit.csp");
				break;
			case "科室常用路径":
				obj.ShowInNewTab("科室常用路径", objNode.id ,"./dhccpw.mrc.deppathwayedit.csp");
				break;
			case "基础字典":
				obj.ShowInNewTab("基础字典", objNode.id ,"./dhccpw.mrc.clinpathway.dic.csp");
				break;
			case "函数库":
				obj.ShowInNewTab("函数库", objNode.id ,"./dhccpw.mrc.baselink.funmain.csp");
				break;
			case "关联项目":
				obj.ShowInNewTab("关联项目", objNode.id ,"./dhccpw.mrc.baselink.itmmain.csp");
				break;
			case "导入路径表单":
				obj.ShowInNewTab("导入路径表单", objNode.id ,"./dhccpw.mrc.importcpw.csp");
				break;
			case "关联医嘱批处理":
				obj.ShowInNewTab("关联医嘱批处理", objNode.id ,"./dhccpw.mrc.changearcim.csp");
				break;
			default:
				window.alert("未知菜单：" + objNode.id);
				break;
		}
	},obj);
	
	obj.objVerisonTree.on("contextmenu",function(objNode, eventObj){
		var menuX = eventObj.getPageX()+30;
		var menuY = (eventObj.getPageY()>(document.body.clientHeight-250))?(document.body.clientHeight-250):eventObj.getPageY();

		if(objNode == null)
			return;
		var arryParts = objNode.id.split("-");
		var objComp = null;
		objNode.select();
		switch(arryParts[1])
		{
			case "Dep":
				break;
			case "Path":
				Ext.getCmp("mnuPublishVer").disable();
				Ext.getCmp("mnuCopyVer").disable();
				Ext.getCmp("mnuSaveAs").disable();   //add by wuqk 2011-10-26
				Ext.getCmp("mnuExport").disable();   //add by wuqk 2011-11-01
				Ext.getCmp("mnuExportForm").disable();
				Ext.getCmp("mnuExportNewForm").disable();
				Ext.getCmp("mnuNewVer").enable();
				Ext.getCmp("mnuDeleteVer").disable();
				//Ext.getCmp("mnuCPWRule").disable();
				obj.objVerTreeContextMenu.showAt([menuX,menuY]);
				break;
			case "Ver":
				if(objNode.text.indexOf("未发布") == -1)
				{
					Ext.getCmp("mnuPublishVer").disable();
					Ext.getCmp("mnuDeleteVer").disable();
					Ext.getCmp("mnuUpdoPublishVer").enable();
				}else{
			  		Ext.getCmp("mnuPublishVer").enable();
			  		Ext.getCmp("mnuDeleteVer").enable();
			  		Ext.getCmp("mnuUpdoPublishVer").disable();
				}
				Ext.getCmp("mnuCopyVer").enable();
				Ext.getCmp("mnuSaveAs").enable();   //add by wuqk 2011-10-26
				Ext.getCmp("mnuExport").enable();   //add by wuqk 2011-11-01
				Ext.getCmp("mnuExportForm").enable();
				Ext.getCmp("mnuExportNewForm").enable();
				Ext.getCmp("mnuNewVer").disable();
				//Ext.getCmp("mnuCPWRule").enable();
				obj.objVerTreeContextMenu.showAt([menuX,menuY]);
				if(arryParts[2] == "1") {
					//判断当前版本是否已发布过，如果发不过则不能修改
					obj.VerReadOnly = "Y";
				}else{
					obj.VerReadOnly = "N";
				}
				break;
			default:
				break;
		}
		//window.alert(objSelNode.id);
		obj.objSelNode = objNode;
	},obj);
	
	obj.objVerisonTree.on("click",function(objNode){
		var arryParts = objNode.id.split("-");
		
		//判断当前版本是否已发布过，如果发布过则不能修改
		if(arryParts[2] == "1"){
			obj.VerReadOnly = "Y";
		}else{
			obj.VerReadOnly = "N";
		}
		
		//只有到版本层次才显示临床路径树
		if(arryParts[1] == "Ver"){
			var objRoot = obj.objContentTree.getRootNode();
			objRoot.setId(objNode.id);
			objRoot.setText(objNode.parentNode.text+"("+objNode.text+")");
			//objRoot.removeAll(true);
			obj.objContentTreeLoader.load(
				objRoot,
				function(){
					this.expand();
				}
			);
			obj.objContentTree.setVisible(true);
			obj.objVerisonTree.setHeight(200); //Add By LiYang 2011-05-21 在显示版本树的时候才改变科室临床路径树的大小
			obj.ShowInNewTab("winLogo","Logo","./dhccpw.mrc.main.csp");
		}
		//fix bug 134816 by pylian  IE11非兼容模式下路径列表-点击【路径列表】下任意菜单的标题单【路径列表】会清空 
		else if(arryParts[1] == "Type"){
			obj.objContentTree.setVisible(false);
			obj.objVerisonTree.setHeight(500);
			
		}else if(arryParts[1] == "Path"){
			obj.objContentTree.setVisible(false);
			obj.objVerisonTree.setHeight(500);
		}else{
			obj.objContentTree.setVisible(false);
			obj.objVerisonTree.setHeight(0); //Add By LiYang 2011-05-21 在显示版本树的时候才改变科室临床路径树的大小
		}
	},obj);
	
	obj.objContentTree.on("dblclick",
		function(objNode)
		{
			if(objNode == null) return;
			var args = objNode.id.split("-");
			switch(args[1])
			{
				case "Ver":
					obj.ShowInNewTab(objNode.id + "",
						"【路径】" + objNode.text, 
						"./dhccpw.mrc.pathveredit.csp?ID=" + args[0] + "&ReadOnly=" + obj.VerReadOnly,
						function()
						{
							obj.objContentTreeLoader.load(
								objNode.parentNode,
								function()
								{
									this.expand();
								}
							);
						}
					);
					break;
				case "Ep":
					obj.ShowInNewTab(objNode.id + "", 
						"【阶段】" + objNode.parentNode.text,
						"./dhccpw.mrc.pathwayep.csp?ID=" + args[0] + "&ReadOnly=" + obj.VerReadOnly,
						function()
						{
							obj.objContentTreeLoader.load(
								objNode.parentNode,
								function()
								{
									this.expand();
								}
							);
						}
					);
					break;
				case "Step":
					obj.ShowInNewTab(objNode.id + "", 
						"【步骤】" + objNode.parentNode.parentNode.text+"_"+objNode.parentNode.text, 
						"./dhccpw.mrc.pathwepstep.csp?ID=" + args[0] + "&ReadOnly=" + obj.VerReadOnly,
						function()
						{
							obj.objContentTreeLoader.load(
								objNode.parentNode,
								function()
								{
									this.expand();
								}
							);
						}
					);
					break;
				case "Categ":
					obj.ShowInNewTab(objNode.id + "", 
						"【项目】" + objNode.parentNode.parentNode.parentNode.text+"_"+objNode.parentNode.parentNode.text+"_"+objNode.parentNode.text, 
						//"./dhccpw.mrc.pathwepstepitem.csp?ID=" + args[0] + "&CateID=" + args[2] + "&ReadOnly=" + obj.VerReadOnly
						"./dhccpw.mrc.formitem.csp?FormStepID=" + args[0] + "&FormItmCatID=" + args[2] + "&ReadOnly=" + obj.VerReadOnly
					);
					break;
				case "Item":
					break;
				default:
					window.alert("路径内容维护数据加载错误,请及时检查？"+ objNode.id);
					break;
			}
		},
		obj
	);
	
	
	obj.ShowInNewTab = function(windowName, caption, cspUrl, closeCallBack, objScope)
	{
		var tabs=Ext.getCmp('cpwMainTab');
		//var tabId = "tab_"+windowName; 
		var tabId = "pnCpwMaintain"; //Modified By LiYang 2011-03-23
		var obj = Ext.getCmp(tabId);
		if (!obj) {
			obj=tabs.add({
				id:tabId
				,title:caption
				,html:"<iframe id='cpwFrame' height='100%' width='100%' src='" + cspUrl + "'/>"
				,closable:false
			});
			obj.on("afterrender", function(){
			//Add By LiYang 2011-02-19增加常用科室自动刷新功能
				var objFrame = document.getElementById("cpwFrame");
				if(objFrame != null) {
					window.RefreshPathVerFn = function()
					{
						var objRootNode = objLeftPanel.objVerisonTree.getRootNode(); //Modified By LiYang 2011-05-28 FixBug 63：临床路径维护--基础字典维护-科室常用路径-添加或移除多条路径后左侧路径数内容翻倍增多
						//objRootNode.clear(true);               //removed by wuqk 2011-07-26  bug 97
						objLeftPanel.objVerisonTreeLoader.load(
							objRootNode,
							function()
							{
								this.expand();
								objLeftPanel.objContentTree.setVisible(false);
							}
						);
					}
					
					//add by wuqk 2011-07-27 刷新路径内容树
					window.RefreshContentTree = function()
					{
						var objRootNode = objLeftPanel.objContentTree.getRootNode(); 
						objLeftPanel.objContentTreeLoader.load(
							objRootNode,
							function()
							{
								this.expand();
							}
						);
					}
				}	
			});	
		}else{
			//var objMainService = ExtTool.StaticServerObject("MainService");
			/*
			if(closeCallBack)
			{
				obj.on("close", closeCallBack, objScope);
			}			
			}*/
			var objFrame = document.getElementById("cpwFrame"); //Modified By LiYang 2011-03-23
			objFrame.src = cspUrl;
			obj.setTitle(caption);
		}
		//obj.show();
	}
	
	obj.ShowInNewTab("tab-Logo","Logo","./dhccpw.mrc.main.csp");
	objLeftPanel = obj;
	
	return obj.pn;
	
}
//var xlSheet;
function ExportDataToExcel(verID,CPWDesc)
{
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			alert("创建Excel应用对象失败!");
			return false;
		}
		xls.visible=false;
		xlBook=xls.Workbooks.Add();
		xlSheet=xlBook.Worksheets.Item(1);
		//var flg=cspRunServerMethod(strMethod,"fillxlSheet",strArguments);
		//var flg=ExtTool.RunServerMethod(MethodGetData,"fillxlSheet",strArguments);
		//DHCMedClinicalRepExport.xls
		//var flg=cspRunServerMethod(strMethod,"fillxlSheet",strArguments);
		var objExport = ExtTool.StaticServerObject('web.DHCCPW.MRC.ImportPathWay');
		var flag=objExport.ExportCW(verID,"fillxlSheet")
		var fname = xls.Application.GetSaveAsFilename(CPWDesc,"Excel Spreadsheets (*.xls), *.xls");
		if(fname!="") xlBook.SaveAs(fname);
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
	return true;
}

function fillxlSheet(xlSheet,cData,cRow,cCol)
{
	var cells = xlSheet.Cells;
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			cells(cRow+i,cCol+j).Value = arryDataY[j];
			//cells(cRow+i,cCol+j).Borders.Weight = 1;
		}
	}
	return cells;
}

function Cleanup(){
	window.clearInterval(idTmr);
	CollectGarbage();
}

//add by zf 20120316 导出标准格式表单
function ExportPathWayForm(CPWID,CPWDesc){
	if (!CPWID) {
		ExtTool.alert("提示","请选择导出表单!");
		return;
	}
	var objServer = ExtTool.StaticServerObject("web.DHCCPW.MR.SysBaseSrv");
	if (objServer){
		var serverInfo = objServer.GetServerInfo();
		if (serverInfo) {
			var tmpList = serverInfo.split(CHR_1);
			if (tmpList.length>=7){
				PrintPath = tmpList[4];
			}
		}
	}
	if (!PrintPath) return;
	
	var filePath = PrintPath + "\\DHCCPWExportForm.xls";
	
	var objFormExport=ExtTool.StaticServerObject("web.DHCCPW.MRC.FormExport");
	var arrSheetList;
	Ext.dhcc.DataToExcelTool.ExcelApp.InitApp();
	var flg=Ext.dhcc.DataToExcelTool.ExcelApp.AddBook(filePath);
	if (flg) {
		arrSheetList=Ext.dhcc.DataToExcelTool.ExcelApp.GetSheetNames();
		if (arrSheetList){
			Ext.dhcc.DataToExcelTool.ExcelApp.GetSheet('Sheet1');
			
			var row=1;
			
			//表单 基本信息
			var strBaseInfo=objFormExport.GetBaseInfo(CPWID);
			if (strBaseInfo!='')
			{
				var arrBaseInfo=strBaseInfo.split(CHR_1);
				for (var indBaseInfo=0;indBaseInfo<arrBaseInfo.length;indBaseInfo++)
				{
					if (arrBaseInfo[indBaseInfo]=='') continue;
					var arrBaseInfoSub=arrBaseInfo[indBaseInfo].split(CHR_2);
					
					Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,1,arrBaseInfoSub[0]);
					Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,1,row,2);
					Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,3,arrBaseInfoSub[1]);
					Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,3,row,8);
					row++;
				}
			}
			
			//表单 列标题
			Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,1,'步骤');
			Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,2,'天数');
			Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,3,'主要诊疗工作');
			Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,3,row,4);
			Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,5,'重点医嘱');
			Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,5,row,6);
			Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,7,'主要护理工作');
			Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,7,row,8);
			row++;
			
			//表单 步骤信息
			var strEpStep=objFormExport.GetEpSteps(CPWID);
			if (strEpStep!='')
			{
				var arrEpStep=strEpStep.split(CHR_1);
				for (var indEpStep=0;indEpStep<arrEpStep.length;indEpStep++)
				{
					if (arrEpStep[indEpStep]=='') continue;
					var arrEpStepSub=arrEpStep[indEpStep].split(CHR_2);
					var EpStepID=arrEpStepSub[0];
					
					Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,1,arrEpStepSub[1]);
					Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,2,arrEpStepSub[2]);
					
					var row0=row;
					
					//主要诊疗工作
					var row1=row;
					var strStepItem=objFormExport.GetEpStepItems(EpStepID,1);
					if (strStepItem!='')
					{
						var arrStepItem=strStepItem.split(CHR_1);
						for (var indStepItem=0;indStepItem<arrStepItem.length;indStepItem++)
						{
							if (arrStepItem[indStepItem]=='') continue;
							var arrStepItemSub=arrStepItem[indStepItem].split(CHR_2);
							Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row1,3,arrStepItemSub[0]);
							Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row1,4,arrStepItemSub[1]);
							row1++;
						}
					}
					
					//重点医嘱
					var row2=row;
					var strStepItem=objFormExport.GetEpStepItems(EpStepID,2);
					if (strStepItem!='')
					{
						var arrStepItem=strStepItem.split(CHR_1);
						for (var indStepItem=0;indStepItem<arrStepItem.length;indStepItem++)
						{
							if (arrStepItem[indStepItem]=='') continue;
							var arrStepItemSub=arrStepItem[indStepItem].split(CHR_2);
							Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row2,5,arrStepItemSub[0]);
							Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row2,6,arrStepItemSub[1]);
							row2++;
						}
					}
					
					//主要护理工作
					var row3=row;
					var strStepItem=objFormExport.GetEpStepItems(EpStepID,3);
					if (strStepItem!='')
					{
						var arrStepItem=strStepItem.split(CHR_1);
						for (var indStepItem=0;indStepItem<arrStepItem.length;indStepItem++)
						{
							if (arrStepItem[indStepItem]=='') continue;
							var arrStepItemSub=arrStepItem[indStepItem].split(CHR_2);
							Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row3,7,arrStepItemSub[0]);
							Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row3,8,arrStepItemSub[1]);
							row3++;
						}
					}
					
					row=row1;
					if (row2>row) row=row2;
					if (row3>row) row=row3;
					
					Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row0,1,row-1,1);
					Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row0,2,row-1,2);
				}
			}
			
			Ext.dhcc.DataToExcelTool.ExcelApp.SaveBook(CPWDesc);
		}
	}
    Ext.dhcc.DataToExcelTool.ExcelApp.Close();
    idTmr=window.setInterval("Cleanup();",1);
}

//add by 20170504 导出新版标准格式表单
function ExportPathWayFormNew(CPWID,CPWDesc){
	if (!CPWID) {
		ExtTool.alert("提示","请选择导出表单!");
		return;
	}
	var objServer = ExtTool.StaticServerObject("web.DHCCPW.MR.SysBaseSrv");
	if (objServer){
		var serverInfo = objServer.GetServerInfo();
		if (serverInfo) {
			var tmpList = serverInfo.split(CHR_1);
			if (tmpList.length>=7){
				PrintPath = tmpList[4];
			}
		}
	}
	if (!PrintPath) return;
	
	var filePath = PrintPath + "\\DHCCPWExportFormNew.xls";
	
	var objFormExport=ExtTool.StaticServerObject("web.DHCCPW.MRC.FormExport");
	var arrSheetList;
	Ext.dhcc.DataToExcelTool.ExcelApp.InitApp();
	var flg=Ext.dhcc.DataToExcelTool.ExcelApp.AddBook(filePath);
	if (flg) {
		arrSheetList=Ext.dhcc.DataToExcelTool.ExcelApp.GetSheetNames();
		if (arrSheetList){
			Ext.dhcc.DataToExcelTool.ExcelApp.GetSheet('路径');
			
			var row=1;
			//表单 基本信息
			var strBaseInfo=objFormExport.GetBaseInfo(CPWID);
			if (strBaseInfo!='')
			{
				var arrBaseInfo=strBaseInfo.split(CHR_1);
				for (var indBaseInfo=0;indBaseInfo<arrBaseInfo.length;indBaseInfo++)
				{
					if (arrBaseInfo[indBaseInfo]=='') continue;
					var arrBaseInfoSub=arrBaseInfo[indBaseInfo].split(CHR_2);
					
					Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,1,arrBaseInfoSub[0]);
					Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,2,arrBaseInfoSub[1]);
				
					row++;
				}
			}
			
			Ext.dhcc.DataToExcelTool.ExcelApp.GetSheet('表单');
			Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(1,1,'步骤');
			Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(2,1,'天数');
			Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(3,1,'主要诊疗工作');
			Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(4,1,'重点医嘱');
			Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(5,1,'主要护理工作');
			//表单 步骤天数信息
			var col=2;
			var strEpStep=objFormExport.GetEpSteps(CPWID);
			if (strEpStep!='')
			{
				
				var arrEpStep=strEpStep.split(CHR_1);
				for (var indEpStep=0;indEpStep<arrEpStep.length;indEpStep++)
				{
					if (arrEpStep[indEpStep]=='') continue;
					var arrEpStepSub=arrEpStep[indEpStep].split(CHR_2);
					var EpStepID=arrEpStepSub[0];
		
					Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(1,col,arrEpStepSub[1]);
					Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(2,col,arrEpStepSub[2]);
				  
				    //主要诊疗工作
					var strStepItem=objFormExport.GetEpStepItems(EpStepID,1);
					if (strStepItem!='')
					{
						var StepItemList="";
						var StepItem="";
						var arrStepItem=strStepItem.split(CHR_1);
						for (var indStepItem=0;indStepItem<arrStepItem.length;indStepItem++)
						{
							if (arrStepItem[indStepItem]=='') continue;
							var arrStepItemSub=arrStepItem[indStepItem].split(CHR_2);
							var StepItem="【】"+arrStepItemSub[1]+'\n';
							var StepItemList=StepItemList+StepItem;
						}
						Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(3,col,StepItemList);
							
					}
					//重点医嘱
					var objSubCateItem=ExtTool.StaticServerObject("web.DHCCPW.MRC.StepItemSubCategory");
					var strSubCateItem=objSubCateItem.GetSubCatByDesc("重点医嘱");
					var arrSubCateItem=strSubCateItem.split(",");
				    var StepList="";
				    for (var indSubCate=0;indSubCate<arrSubCateItem.length;indSubCate++)
					{
						if (arrSubCateItem[indSubCate]=='') continue;
						var aSubCate=arrSubCateItem[indSubCate].split("^")[1];
					
					    var strStepItem=objFormExport.GetEpStepItems(EpStepID,2);
						if (strStepItem!='')
						{
							var StepItemList="",OrderType="",StepItem="";
							
							var arrStepItem=strStepItem.split(CHR_1);
							for (var indStepItem=0;indStepItem<arrStepItem.length;indStepItem++)
							{
								if (arrStepItem[indStepItem]=='') continue;
								var arrStepItemSub=arrStepItem[indStepItem].split(CHR_2);
				             		if (arrStepItemSub[0]==aSubCate) {
									var OrderType=arrStepItemSub[0]+'\n';
									var StepItem="【】"+arrStepItemSub[1]+'\n';
									var StepItemList=StepItemList+StepItem;
								}
						       
							}
						}
						var StepList=StepList+OrderType+StepItemList;
					}	
					Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(4,col,StepList);
					
					//主要护理工作
					var strStepItem=objFormExport.GetEpStepItems(EpStepID,3);
					if (strStepItem!='')
					{
						var StepItemList="";
						var StepItem="";
						var arrStepItem=strStepItem.split(CHR_1);
						for (var indStepItem=0;indStepItem<arrStepItem.length;indStepItem++)
						{
							if (arrStepItem[indStepItem]=='') continue;
							var arrStepItemSub=arrStepItem[indStepItem].split(CHR_2);
							var StepItem="【】"+arrStepItemSub[1]+'\n';
							var StepItemList=StepItemList+StepItem;	
							
						}
						Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(5,col,StepItemList);
					}
					col++;
				}
				
			}
			
		}
				
			
	}
	
	Ext.dhcc.DataToExcelTool.ExcelApp.SaveBook(CPWDesc);

    Ext.dhcc.DataToExcelTool.ExcelApp.Close();
    idTmr=window.setInterval("Cleanup();",1);
}
