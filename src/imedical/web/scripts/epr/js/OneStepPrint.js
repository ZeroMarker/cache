function showRecordWin(){
	//打印方案维护弹出窗口
	var winRecord = new Ext.Window({
		id: 'recordWin',
		layout: 'fit', // 自动适应Window大小
		width: 1000,
		height: 600,
		title: '打印记录',
		closeAction: 'close',
		// raggable: true, 		//不可拖动
		modal: true, //遮挡后面的页面
		resizable: true, // 重置窗口大小
		autoScroll:true,
		html: '<iframe id="frmRecord" style="width:100%; height:100%" src="dhc.epr.onestepprintrecord.csp"></iframe>'
	});
	
	winRecord.show();
}

//debugger;
Ext.QuickTips.init();
    var northPanel = new Ext.FormPanel({
	id:'northPanel',
	labelWidth: 75,
	labelAlign: 'right',
	frame:true,
	items: [{
		xtype:'fieldset',
		title: '基本信息',
		collapsible: true,
		autoHeight:true,
		defaults: {width: 210},
		defaultType: 'textfield',
		items:[{
			id:'patName',
			fieldLabel: '姓名',
			name: 'patName',
			value:patName,
			style:'color:blue;',
			readOnly:true,
			listeners:{
				'focus':function(tfd){
					tfd.blur();
				}
			}
		},{
			id:'patSex',
			fieldLabel: '性别',
			name: 'patSex',
			value:patSex,
			style:'color:blue;',
			readOnly:true,
			listeners:{
				'focus':function(tfd){
					tfd.blur();
				}
			}
		},{
			id:'currentDept',
			fieldLabel: '科室',
			name: 'currentDept',
            value:currentDept,
			style:'color:blue;',
			readOnly:true,
			listeners:{
				'focus':function(tfd){
					tfd.blur();
				}
			}
		}]
	}],
    tbar: [
		{
			id : 'btnRecord',
			cls: 'x-btn-text-icon' ,
			icon:'../scripts/epr/Pics/browser.gif',
			text : '打印记录',
			handler : showRecordWin
		},
		'->', 
		'-',
		{
			id:'btnPrint',
			name:'btnPrint',
			text:'打印',
			cls: 'x-btn-text-icon' ,
			icon:'../scripts/epr/Pics/btnConfirm.gif',
			pressed:false,
			handler:printClick
		},
		'-'
		//{id:'btnCancel',name:'btnCancel',text:'取消',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/btnConfirm.gif',pressed:false,handler:cancelClick}
	]
});

var Tree = Ext.tree;
var treeLoader = new Tree.TreeLoader({ 
	dataUrl: "../web.eprajax.onestepprint.cls?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&UserID=" + userID + "&CTLocID=" + ctlocid + "&SSGroupID=" + ssgroupid + "&EKGTypeEnabled=" + encodeURI(EKGTypeEnabled)
});

var tree = new Tree.TreePanel({
	//el:"currentDocs",
	rootVisible: false,
	autoScroll:true,
	trackMouseOver:false,
	//title:'病历范围',
	animate:false,
	containerScroll:true,
	bodyStyle:'padding:5px 5px 0',
	lines:true, 
	checkModel:'cascade',
	//autoHeight:true,
	height:500,
	border:true,
	loader : treeLoader,
	id:"myTree"
});
	
var rootNode = new Tree.AsyncTreeNode({
	text : '请选择打印范围',
	nodeType: 'async',
	draggable : false,
	id : "RT00"
});	

//抛出异常时的处理				
treeLoader.on("loadexception", function(tree, node, response) {
	var obj = response.responseText;
	alert(obj);
});
    
tree.setRootNode(rootNode);
rootNode.expand(true);
    
tree.on("checkchange", function(node,checked) {
	if (node.leaf){
		if (!checked){   
			//任一子节点未选中，则不选中父节点
			node.parentNode.attributes.checked = false;
			node.parentNode.getUI().checkbox.checked = false;
		}
		else{
			//选中所有子节点，则选中父节点
			var totChecked = true;
			for ( var i=0; i<node.parentNode.childNodes.length; i++){
				if (!node.parentNode.childNodes[i].attributes.checked){
					totChecked = false;
					break;
				}
			}
			node.parentNode.attributes.checked = totChecked;
			node.parentNode.getUI().checkbox.checked = totChecked;
		}   
	}
	else{
		//选中父节点，则选中所有子节点
		for (var i=0; i<node.childNodes.length; i++){
			node.childNodes[i].attributes.checked = checked;
			node.childNodes[i].getUI().checkbox.checked = checked;
		}
	}  
});   

var view = new Ext.Viewport({
	id: 'printViewPort',
	shim: false,
	animCollapse: false,
	constrainHeader: true, 
	collapsible: true,
	margins:'0 0 0 0',           
	layout: "border",  
	border: false,              
	items: [{
		border:true,
		region:'north',
		height:150,
		//layout:'north',
		split: true,
		collapsible: true,  
		items:northPanel 
	},{
		border:true,
		region:'center',
		layout:'fit',
		split: true,
		collapsible: true,  
		items:tree              
    }]
});

// 不能够设定字体颜色，所以注释掉  modify by lina 2014-11-06
//SetTextFieldDisable();  

tree.render('tree');
tree.doLayout();
  
function SetTextFieldDisable(){
    var txtUserName = Ext.getCmp('patName');
    txtUserName.setDisabled(true);
    var txtUserLocDes = Ext.getCmp('patSex');
    txtUserLocDes.setDisabled(true);
    var txtCurDept = Ext.getCmp('currentDept');
    txtCurDept.setDisabled(true);
}

function printClick(){   
    //debugger;
    var count=0;
    var arrCategory = new Array();
    var arrCategoryDetail = new Array();
    
    for(var i = 0; i<rootNode.childNodes.length; i++){
	    var cgNode = rootNode.childNodes[i];
	    var cgID = cgNode.id;
		
	    var cdInfo = ""; 
	    var cdPS = "";
	    for (var j=0; j<cgNode.childNodes.length; j++){
	        var ccNode = cgNode.childNodes[j];
		
	        if (ccNode.leaf && ccNode.attributes.checked){
	                        var detailInfo = ccNode.attributes.detailInfo;
				//增加图片扫描节点打印，扫描节点detailInfo中的形式为PS^图片1路径^图片2路径^图片3路径...   --add by yang 2012-9-21
				arrItems= detailInfo.split("^");
				if (arrItems[0] == "PS") {
					if (cdPS ==""){
						cdPS = detailInfo
					}
					else{
						cdPS = cdPS + detailInfo.substring(2)
					}
				}
				else {
					if (cdInfo == "") {
						cdInfo = detailInfo;
					}
					else {
						cdInfo = cdInfo + "!" + detailInfo;
					}
				}
	        }
	    }
	    
	    if (cdInfo != ""){
			if (cgID == "CG07") {
				arrCategory.push(cgID);
				arrCategoryDetail.push(cdInfo);
				if (cdPS != "") {
					arrCategory.push("PS");
					arrCategoryDetail.push(cdPS);
				}
			}
			else {
				arrCategory.push(cgID);
				arrCategoryDetail.push(cdInfo);
			}
	    }
		else if(cdPS != ""){
			arrCategory.push("PS");
			arrCategoryDetail.push(cdPS);
		}
	}
    
	if (arrCategory.length < 1){
    	Ext.MessageBox.alert('操作提示','请选择打印范围');
        return;
    }
	
    printSelectedItem(arrCategory, arrCategoryDetail);
}

function cancelClick()
{
    //win.close(this);
}