var list = [];
var curNode;
var curIndex = -1;

//点击"确定"按钮
function confirm()
{
	//把list清空
	list = [];
	curIndex = -1;
	getNodes();
	changeStyle();
	btnIsEnable();
}

//设置按钮是否可点击
function btnIsEnable() 
{
    //debugger;
    if (list.length <= 1) {
        //符合要求的数组为空或者只有一个节点,同时禁用"上一个"和"下一个"按钮
        Ext.getCmp('btnprev').disable();
        Ext.getCmp('btnnext').disable();
    }
    else {
        if (curIndex == 0) {
            //curIndex在起始位置,禁用"上一个"按钮
            Ext.getCmp('btnprev').disable();
            Ext.getCmp('btnnext').enable();
        }
        else if (curIndex == list.length - 1) {
            //curIndex到末尾,禁用"下一个"按钮
            Ext.getCmp('btnprev').enable();
            Ext.getCmp('btnnext').disable();
        }
        else {
            //正常情况都可点击
            Ext.getCmp('btnprev').enable();
            Ext.getCmp('btnnext').enable();
        }
    }
}

//将节点的背景色改变样式
function changeStyle() 
{
    if (curNode != null) {
        curNode.getUI().removeClass("nodeSelected");
    }

    for (var i = 0; i < list.length; i++) {
        curNode = list[i];
        curIndex = i;
        list[i].getUI().addClass("nodeSelected");
        return;

    };
}

//取得整棵树的所有符合搜索要求节点
function getNodes()
{
	var tree = Ext.getCmp("myTree");
	getChildrenNode(tree.root);
}

//递归遍历树中node节点的所有子节点, 将符合搜索要求的节点纪录到list数组中
function getChildrenNode(node,type) 
{
	
    if (node.leaf && node.text.indexOf(Ext.getCmp("txtEntryTitle").getValue()) > -1) {
        list.push(node);
    }
    else {
        for (var i = 0; i < node.childNodes.length; i++) {
            getChildrenNode(node.childNodes[i]);
        }
    }
}

//上一个按钮
function prev() 
{
    if (curIndex == 0) {
        return;
    }
    curNode.getUI().removeClass("nodeSelected");
    curIndex--;
    curNode = list[curIndex];
    curNode.getUI().addClass("nodeSelected");
    btnIsEnable();
}

//下一个按钮
function next() 
{
    if (curIndex == list.length - 1) {
        return;
    }
    curNode.getUI().removeClass("nodeSelected");
    curIndex++;
    curNode = list[curIndex];
    curNode.getUI().addClass("nodeSelected");
    btnIsEnable();
}
function sure()
{
	var b = tree.getChecked();
	var checkid = new Array;// 存放选中id的数组
    for (var i = 0; i < b.length; i++) {
    checkid.push(b[i].id);// 添加id到数组
    }
    //alert(checkid.toString());
	window.returnValue = checkid;
	window.close();
	
}

//定义工具条
var treeTbar = [{
					id:'txtEntryTitle',
					emptyText:'评估项目',
					xtype: 'textfield',
					//enable:false,
					width: 350
				},
				"-",
				{
					id:'btnconfirm',
					text:'搜索',
					cls: 'x-btn-text-icon',
					icon:'../scripts/epr/Pics/btnConfirm.gif',
					pressed:false,
					handler:confirm
				},
				"->", "-", 
				{
					id:'btnprev',
					text:'上一个',
					cls: 'x-btn-text-icon',
					icon:'../scripts/epr/Pics/pageupbrowser.gif',
					pressed:false,
					disabled:true,
					handler:prev
				},
				"-", 
				{
					id:'btnnext',
					text:'下一个',
					cls: 'x-btn-text-icon',
					icon:'../scripts/epr/Pics/pagedownbrowser.gif',
					pressed:false,
					disabled:true,
					handler:next
				}];

var treeBbar = ["->",{
					id:'btnSure',
					text:'确认',
					cls: 'x-btn-text-icon',
					icon:'../scripts/epr/Pics/s.gif',
					pressed:false,
					handler:sure
				}];
var Tree = Ext.tree;
var treeLoader = new Tree.TreeLoader( {
	dataUrl : "../EPRservice.Quality.EntryTree.cls?RuleID=" + RuleID,
	baseAttrs:{uiProvider:Ext.ux.TreeCheckNodeUI}
	});

var tree = new Tree.TreePanel({
    el: "currentDocs",
    rootVisible: false,
    autoScroll: true,
    trackMouseOver: false,
    animate: false,
    collapsible: true, //展开和闭合
    //autoShow:true, 
    //enableDD:true,
    containerScroll: true,
    lines: true,
    checkModel:'cascade',
    onlyLeafCheckable: true,
    height: 595,
    width:596,
    border: false,
    loader: treeLoader,
    id: "myTree",
    tbar: treeTbar,
	bbar: treeBbar
});


var root = new Tree.AsyncTreeNode( {
	text : '质控项目',
	nodeType: 'async',
	checked:false,
	expanded:true , //展开
	draggable : false,
	id : "root^0"
});

//取得主页面上的按钮将主页面上的txtEntryTitle中的内容传到模式页面中,同时加载confirm事件
function getEntryTitle()
{
	Ext.getCmp("txtEntryTitle").setValue(unescape(EntryTitle));
}

//抛出异常时的处理				
treeLoader.on("loadexception", function(tree, node, response) {
	var obj = response.responseText;
	alert(obj);
});	

tree.on('load', function(){

});

//点击treePanel事件
tree.on('click',function(node,event){
	selectTreeNode = node;
	var nodeNote=[]
	var nodeNote = node.id;
	var checkid = new Array;
	var arr = nodeNote.split('^');
	var type = arr[0];

	if(type == "CG" || type == "RT")
	{
		//节点类型为"CG",进一步展开下一层节点
		return;
	}
	else
	{
		//类型为"LF",叶子节点??在此写关闭窗体??填充数据等操作
		checkid.push(nodeNote)
		window.returnValue = checkid;
		window.close();
	}
});
	
tree.setRootNode(root);
root.expand(true);
tree.render();

//在输入完评估项目名称后??新增快捷键Enter
var map = new Ext.KeyMap(Ext.getDoc(), {
	key: 13,	// Enter
	fn: function()
	{
		//Ext.Msg.alert('KEY MAP', 'You just hit Enter');
		confirm();
	},
	scope: this
}); 
map.addBinding({
	key: 38,	//上箭头
	fn: function()
	{
		prev();
	},
	scope: this
});
map.addBinding({
	key: 40,	//下箭头
	fn: function()
	{
		next();
	},
	scope: this
});
	